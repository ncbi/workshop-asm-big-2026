# Plasmids and Metagenomes

In this project we're going to examine a set of metagenomes and some plasmids we pull out and assemble from them.

This project uses data from the paper [Cheng et al., 2020 Cartography of opportunistic pathogens and antibiotic resistance genes in a tertiary hospital environment](https://pmc.ncbi.nlm.nih.gov/articles/PMC7303012/) 
as a starting point. 


We're going to:
- Look at the results of the "STAT" tool from SRA for taxanomic representation in the metagenome.
- From a set of assembled plasmids indicated in the paper, we've selected some interesting ones and we're going to pull out reads and try to assemble them from metagenomes.
- Use BLAST to see how well our assemblies represent the target plasmids.
- Look at AMR, virulence, and stress-resistance genes in those plasmids.
- Use Pebblescout to see where they likely came from and see if we can find some assemblies and metagenomes that have them.

See [software.md](software.md) for a list of the scientific software used below.

## 1. Make a working directory

    mkdir $HOME/microbiome
    cd $HOME/microbiome

## 2. Grab some interesting plasmids from the paper

### 2.1 Get the assemblies
```
## obtain plasmid assemblies
wget https://ndownloader.figshare.com/files/21229998
mv 21229998 contigs.fa.gz
gunzip contigs.fa.gz
```

### 2.2 Get some information about the plasmids from supplementary data
```
## obtain information about the plasmid assemblies
wget https://ndownloader.figshare.com/files/21229983
mv 21229983 plasmid_info.tab

## get list of contigs with AMR genes from the paper
git clone https://github.com/csb5/hospital_microbiome.git

egrep -i 'ctx|ges|tem|shv' ./hospital_microbiome/tables/plasmid_info.dat | awk '{ if ($5 >= 0) print $0}' | sort -nrk5 | head -3 | cut -f2 >plasmid.list
## result is 3 plasmids
```
We should have 3 plasmids in the list now
```
    cat plasmid.list
```
You should see:
```
p_1687
p_83
p_3128
```

### 2.3 Extract the interesting plasmids from the sequence contigs we downloaded
```
mkdir plasmids

for i in `cat plasmid.list`
do
    # fagrep $i contigs.fa >plasmids/$i.fna
    seqkit grep -n -r -p "$i\$" contigs.fa > plasmids/$i.fna
done
```

### 2.4 For convenience concatenate those into a single file

```
    cat plasmids/*.fna > plasmid_references.fasta
```

## 3. Download and filter reads for a couple of metagenomic samples

### 3.1 Download reads using `prefetch` and `fasterq-dump`

```
cat > sra.acc <<END
ERR3209766
ERR3209768
END
```
<!-- deleted ERR3209849 -->

```
date
for acc in `cat sra.acc`
do
    echo $acc
    prefetch $acc
    fasterq-dump --split-files $acc
    ls -l *.fastq
    date
done

```

### 3.2 Extract read-pairs aligning to the plasmid

We're going to isolate the read-pairs aligning to the plasmid to make the assembly problem easier and faster for the assembler. 

These smaller sets of reads are also useful if you want to look closer at the sequence of the reads and how individual reads align to the plasmid reference.

```
bwa-mem2 index plasmid_references.fasta
for acc in `cat sra.acc`
do
    time bwa-mem2 mem -t 8 plasmid_references.fasta ${acc}_1.fastq ${acc}_2.fastq | \
        samtools view -u -F 8 - | \
        samtools fastq -1 ${acc}_mapped_1.fastq -2 ${acc}_mapped_2.fastq \
            -0 /dev/null -s /dev/null -
done
```

This should take 3-5 minutes to complete.

### 3.3 Look at how many reads we have filtered down to

```
seqkit stats *.fastq
```
You should see something like:
```
file                       format  type   num_seqs      sum_len  min_len  avg_len  max_len
ERR3209766_1.fastq         FASTQ   DNA   8,296,848  828,470,982       30     99.9      101
ERR3209766_2.fastq         FASTQ   DNA   8,296,848  828,470,737       30     99.9      101
ERR3209766_mapped_1.fastq  FASTQ   DNA      41,211    4,118,496       33     99.9      101
ERR3209766_mapped_2.fastq  FASTQ   DNA      41,211    4,118,496       33     99.9      101
ERR3209768_1.fastq         FASTQ   DNA   4,036,058  405,359,151       30    100.4      101
ERR3209768_2.fastq         FASTQ   DNA   4,036,058  405,359,074       30    100.4      101
ERR3209768_mapped_1.fastq  FASTQ   DNA     124,749   12,526,481       30    100.4      101
ERR3209768_mapped_2.fastq  FASTQ   DNA     124,749   12,526,479       30    100.4      101
```

## 4. Now we're going to look at the resistome data from Supplementary data 2

[Supplementary File 2](https://github.com/NCBI-Codeathons/asm-ngs-workshop/raw/main/blob/supplementary_file_2.xlsx) has information on the taxonomic content and AMR content of shotgun metagenomic samples.

We're looking more closely at a subset of the runs listed here:

|Date of Collection | Sample ID | Timepoint Hospital | Floor | Ward Type        | Ward/Room Number |   Sample Type  | Bed Number | Surface Material | Illumina Library ID | SRR             |
| ----------------- | --------- | ------------------ | ----- | ---------------- | ---------------- | -------------- | ---------- | ---------------- | ------------------- | --------------- |
|        2017-11-28 | HMBR127_02|         2          |     8 | Isolation room   |                3 | Bed Rail       |            | Plastic          | WEE037              |      ERR3209766 |
|        2017-11-24 | HMBR133   |         1          |    11 | Isolation room   |                5 | Bed Rail       |            | Plastic          | WEE039              |      ERR3209768 |
<!-- |        2017-11-23 | HMBL103   |         1          |     7 | Standard         |                3 | Bedside Locker | 5          | Wood             | WEE120              |      ERR3209849 |
-->

### 4.1 Check out the SRA stat tool results for these isolates

The Analysis tab of the Run selector interface from SRA shows taxonomic breakdowns of the reads based on alignment to a database of taxon-specific kmers. This is similar to the process used by Kraken if you're familiar with that.

#### 4.1.1 Go to https://www.ncbi.nlm.nih.gov/

#### 4.1.2 Search for the SRA run accession ERR3209768

![Search for ERR3209768 on the NCBI home page](https://raw.githubusercontent.com/ncbi/workshop-asm-2026/refs/heads/main/images/metagenomics1-search.png)

#### 4.1.3 Click the link to see the SRA record

![Click the link to get to the SRA record](https://raw.githubusercontent.com/ncbi/workshop-asm-2026/refs/heads/main/images/metagenomics2-link_to_sra.png)

#### 4.1.4 Click the SRA accession ERR3209768 in the table at the bottom of the record to get to the Run Browser

![Click the accession to get to the Run Browser](https://raw.githubusercontent.com/ncbi/workshop-asm-2026/refs/heads/main/images/metagenomics3-go_to_run_browser.png)
  ([Direct link](https://trace.ncbi.nlm.nih.gov/Traces/?run=ERR3209768))

#### 4.1.5 Click Analysis to see the STAT tool results

![Click the analysis tab to see STAT tool results](https://raw.githubusercontent.com/ncbi/workshop-asm-2026/refs/heads/main/images/metagenomics4-analysis.png)

#### 4.1.6 Click to expand some of the taxa in the list view.

#### 4.1.7 Try the Krona view below and look for Klebsiella

![Click *Show Krona View*](https://raw.githubusercontent.com/ncbi/workshop-asm-2026/refs/heads/main/images/metagenomics5-krona.png)

## 5. Assemble the filtered reads with SAUTE 

### 5.1 Run SAUTE for each for each readset and each target

[SAUTE](https://github.com/ncbi/SKESA) ([Souvorov and Agarwala, 2021](https://pmc.ncbi.nlm.nih.gov/articles/PMC8293564/) is a reference guided assembler developed at NCBI. We're going to use that to assemble the sequences we pulled out to see if we can find these plasmids in the sequences.

Assemble the reads using SAUTE with the plasmids as the targets 

```
echo `date` Starting assemblies >> log
date
for acc in `cat sra.acc`
do
    for plasmid in `cat plasmid.list`
    do
        saute --targets ./plasmids/$plasmid.fna \
            --reads ${acc}_mapped_1.fastq,${acc}_mapped_2.fastq \
            --gfa $acc.$plasmid.gfa \
            --all_variants $acc.$plasmid.all.fa --max_variants 1 \
            --target_coverage 0.1 --extend_ends  --cores 4
    done
    date
done
echo `date` Finished assemblies >> log
```

Here we used nested for loops. The first loop runs for every accession we used, and the second for every target.

### 5.2 Take a look at what we assembled
```
ls -l *.all.fa
```
```
-rw-r--r-- 1 jupyter-aprasad jupyter-aprasad 188342 May 23 14:25 ERR3209766.p_1687.all.fa
-rw-r--r-- 1 jupyter-aprasad jupyter-aprasad      0 May 23 14:25 ERR3209766.p_3128.all.fa
-rw-r--r-- 1 jupyter-aprasad jupyter-aprasad 104661 May 23 14:26 ERR3209766.p_83.all.fa
-rw-r--r-- 1 jupyter-aprasad jupyter-aprasad 183467 May 23 14:28 ERR3209768.p_1687.all.fa
-rw-r--r-- 1 jupyter-aprasad jupyter-aprasad      0 May 23 14:28 ERR3209768.p_3128.all.fa
-rw-r--r-- 1 jupyter-aprasad jupyter-aprasad 182100 May 23 14:29 ERR3209768.p_83.all.fa
```

We can use seqkit to get a slightly closer look at the assemblies

```
seqkit stats *.all.fa
```
```
processed files:  9 / 9 [======================================] ETA: 0s. done
file                      format  type  num_seqs  sum_len  min_len   avg_len  max_len
ERR3209766.p_1687.all.fa  FASTA   DNA          2  188,008   87,905    94,004  100,103
ERR3209766.p_3128.all.fa                       0        0        0         0        0
ERR3209766.p_83.all.fa    FASTA   DNA          3  104,416   27,125  34,805.3   39,503
ERR3209768.p_1687.all.fa  FASTA   DNA          3  182,728   20,518  60,909.3  127,364
ERR3209768.p_3128.all.fa                       0        0        0         0        0
ERR3209768.p_83.all.fa    FASTA   DNA          3  181,592   34,554  60,530.7   83,126
```

```
seqkit fx2tab -l -n plasmids/*
```
```
p_1687  195980
p_3128  227286
p_83    145343
```

It looks like there are plasmid assemblies from ERR3209766 and ERR3209768 to p\_1687 and p\_83.
We'll take a closer look at *p_1687*

## 6. Blast assemblies against the reference using web blast

From this we can get an idea of how our assemblies cover the reference.

#### 6.1 Download the assembly files

Download *`ERR3209768.p_1687.all.fa`* and the plasmid references `plasmid_references.fasta` by right clicking on the filename in the Jupyter file list and selecting "Download".

![Right click the filename and select download](https://raw.githubusercontent.com/ncbi/workshop-asm-2026/refs/heads/main/images/metagenomics7-file_download.png)

#### 6.2 Go to nucleotide blast 

    [Nucleotide BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&PAGE_TYPE=BlastSearch) - <https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&PAGE_TYPE=BlastSearch>

#### 6.3 Select the reference plasmids file (plasmid_references.fasta) as your "Query Sequence" and select "Align two or more seuences"

Click *Choose File* and select the `plasmid_references.fasta` file you just downloaded then click the *Align two or more sequences* checkbox.

![Choose plasmid_references.fasta as the Query sequence and click Align two or more sequences](https://raw.githubusercontent.com/ncbi/workshop-asm-2026/refs/heads/main/images/metagenomics8-query_sequence.png)

#### 6.4 Choose the assembly file (ERR3209768.p_1687.all.fa) as your "Subject Sequence"

![Select ERR3209768.p_1687.all.fa as the subject sequence](https://raw.githubusercontent.com/ncbi/workshop-asm-2026/refs/heads/main/images/metagenomics9-subject_sequence.png)

#### 6.5 Leave all other options the default and click ![BLAST](https://raw.githubusercontent.com/ncbi/workshop-asm-2026/refs/heads/main/images/metagenomics11-blast_button.png)

#### 6.6 View the Graphic Summary

![View the Graphic Summary](https://raw.githubusercontent.com/ncbi/workshop-asm-2026/refs/heads/main/images/metagenomics10-graphic_summary.png)

Look at the Graphic Summary tab and see that there is pretty good coverage over the query plasmid p_1687 in three contigs.

Do the same for the ERR3209766.p_1687.all.fa assembly


## 7. Examine the antibiotic, stress resistance, and virulence genes

### 7.1 Run AMRFinderPlus on the assemblies and the reference

[AMRFinderPlus](https://github.com/ncbi/amr/wiki) is software and a database that identifies antibiotic resistance-associated genes and point mutations in assembled sequence. With the --plus option it also identifies select stress resistance and virulence genes.

```
amrfinder -n ERR3209766.p_1687.all.fa --plus > ERR3209766.p_1687.all.amrfinder
amrfinder -n ERR3209768.p_1687.all.fa --plus > ERR3209768.p_1687.all.amrfinder
amrfinder -n plasmids/p_1687.fna --plus > p_1687.amrfinder
```

### 7.2 Take a look at the results
```
d2l ERR3209766.p_1687.all.amrfinder
d2l p_1687.amrfinder
```

Notice there were many more genes identified in our assembly, and that the reference has a lot of "PARTIALX" hits from AMRFinderPlus. That indicates that our assembly is probably of higher quality then the reference.

## 8. Can we figure out the taxon this plasmid commonly occurs in using pebblescout?

We will use [pebblescout](https://pebblescout.ncbi.nlm.nih.gov/#view=search) to search for this plasmid in all assemblies at NCBI.

Pebblescout is a way of very quickly searching for sequences that likely contain our query sequence based on the selection of 25mers. It looks at the presence of kmers weighing rare kmers more highly than common ones.

### 8.1 Go to [Pebblescout](https://pebblescout.ncbi.nlm.nih.gov/#view=search) 

### 8.2 Query using the assembly we already downloaded, `ERR3209768.p_1687.all.fa`. 

Click **Choose File** and select `ERR3209768.p_1687.all.fa` from your downloads directory.

### 8.3 Select the WGS, Volume 1 index

### 8.4 Click View to see the results

- Note the **%coverage** and **PBScore** values. 
- Open some of the biosample accessions in a new tab to get an idea of what these isolates are

We see several assemblies with 90% or more of the kmers covered and they're all _Klebsiella pneumoniae_, so we can surmise that this plasmid often occurs in _Klebsiella pneumoniae_.

### 8.5 Take a top hit and look at it in MicroBIGG-E

These _Klebsiella pneumoniae_ assemblies should be in NCBI Pathogen Detection where you can see more about them. Try searching [NCBI Pathogen Detection](https://www.ncbi.nlm.nih.gov/pathogens/) for one or more of the top hits E.g., https://www.ncbi.nlm.nih.gov/pathogens/isolates/#SAMN16824518  Use the cross browser selection to see the AMRFinderPlus results for that isolate. Looks like many of the same genes we saw earlier. 

#### Search for SAMN16824518 in MicroBIGG-E

- Go to [MicroBIGG-E](https://www.ncbi.nlm.nih.gov/pathogens/microbigge/) and paste in SAMN16824518
  ([direct link](https://www.be-md.ncbi.nlm.nih.gov/pathogens/microbigge/#SAMN16824518)
- Sort by contig ID and notice some of the same sets of genes

#### Search for SAMN16824518 in the Isolates browser

- Use cross-browser selection or search for SAMN16824518
- Note that it isn't in a "SNP cluster", and the **Location** and **AMR genotypes** columns



# Stretch project

Use NCBI Datasets to download one of the assemblies we found with pebblescout and see if we can pull out contigs aligning to our contig to see if the same plasmid is actually there.


######################################################################

