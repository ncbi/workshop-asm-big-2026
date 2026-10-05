# Retrieving Genomic Data and Metadata Using the NCBI Datasets Command-Line Tool


## 1. NCBI Datasets: an overview 

[NCBI Datasets](https://www.ncbi.nlm.nih.gov/datasets/) is a resource that allows users to download data and metadata from [API](https://www.ncbi.nlm.nih.gov/datasets/docs/v2/reference-docs/rest-api/), [web](https://www.ncbi.nlm.nih.gov/datasets/) and [command-line tool](https://www.ncbi.nlm.nih.gov/datasets/docs/v2/download-and-install/). In this workshop, we will be focusing on the command-line tool, its structure and organization.

<div style="text-align: center;">
   <img src="https://www.ncbi.nlm.nih.gov/datasets/docs/v2/datasets_getting_started.png" alt="getting-started" style="width: 800px;">
</div>


**Command-line tools: *datasets* and *dataformat***

While the web interface is helpful, there are times when it's more convenient to access genomes through a command-line environment. For example, let's say you are working on your institution's high-performance computing (HPC) system and you need to download dozens (or hundreds of genomes). Even if you're using the Datasets web interface, this would potentially be a two step process: 

1. Download the genome data package locally;
2. Transfer the files to the HPC system.

With the NCBI Datasets command-line interface (CLI), you can do this process in a single step. Our CLI allows users to access not only genomes, but also genes, ortholog sets and virus genomes. 

The program follows a hierarchy that makes it easier for users to select exact which options they would like to use. In addition to the program commands, additional flags are available for filtering the results. We will go over those during this tutorial.

<div style="text-align: center;">
<img src="https://www.ncbi.nlm.nih.gov/datasets/docs/v2/datasets_schema_complete_v18.png" alt="datasets" style="width: 800px;">
</div>

In this virtual machine, we have the necessary tools installed for you to explore NCBI Datasets without the need to configure anything. When you decide to use NCBI Datasets on your own machine or HPC system, you need to install it. More information on how to install NCBI Datasets can be found in [our documentation page](https://www.ncbi.nlm.nih.gov/datasets/docs/v2/download-and-install/).

The NCBI Datasets CLI command structure is very intuitive. If you take a look at the diagram below, you will notice that the commands are built by choosing one option from each vertical rectangle. Let's start!

<div style="text-align: center;">
<img src="https://github.com/ncbi/workshop-asm-big-2026/blob/9d026150ac4beaeb3daef03c20d71e8084e8cf40/datasets/images/command-choice.png" alt="commands" style="width: 700px;">
</div>

In addition to *datasets*, we also have *dataformat*, a companion tool to explore and convert metadata to TSV or Excel formats. We will cover the *dataformat* command syntax and use in the metadata metadata section below.


## 2. Retrieving bacterial data and metadata using *datasets*

Bacteria is the taxonomic group with the largest number of available genomes - no surprises here. Currently there are 3.13 million bacterial genomes (on 05/26/2026), with *Salmonella* being the most represented taxon (> 618,000 genome sequences).  

As expected, retrieving such a large number of genome sequences is a challenging task. In this workshop, we will show some strategies to potentially improve your download experience and data retrieval from NCBI using *datasets*. 


### 2.1. Downloading a "small" genome data package
 
Small and large are very relative terms. When thinking about genome projects, that answer also can vary depending on the taxon in question. For vertebrates, genome sizes varies tremendously (more than 200 times), from around 400 million base pairs (Mb) in the fugu (*Tetraodon nigroviridis*) to almost 90 billion base pairs (Gb) in the South American Lungfish (*Lepidosiren paradoxa*). In Bacteria, genome sizes also vary significantly, from around 0.1 Mb in *Candidatus* Nasuia deltocephalinicola                                                                                                                                                                                                                                                                                                                                                                                               to 15 Mb in *Streptomyces prasinosporus*. 

<div style="text-align: center;">
<img src="https://tom-e-white.com/datavision/assets/img/05-genome-size.png" alt="genome-size" style="width: 700px;">
<figcaption>Image source: Tom E. White <a href="https://tom-e-white.com/datavision/05-genome-size.html">Datavision 2020</a></figcaption>
</div>
                                                       
Back to the idea of small and big genome projects: if we consider genome size, a project that aims to evaluate 1000 human genomes will involve roughly 3,100 Gb, while the same concept (1,000 genomes) for an average bacterial genome (around 5 Mb) will entail only 5 Gb, which is 620 times less data. In addition to the storage space, we should also consider the network over which the download is happening: if your network is not very fast or reliable, you would benefit from using an option that allows for downloads to be resumed and that can handle slower speeds.  

For our small example, let's look into *Salmonella bongori* (101 genomes). Using *datasets*, you can download the genomes by NCBI TaxID, scientific name and common name (when available). In this case, we're using NCBI TaxID.   


**Download *S. bongori* genomes by taxid:**

```
datasets download genome taxon 54736 --filename 54736.zip
```
**Unzip the package and inspect the folder structure and contents**

```
unzip 54736.zip -d sbongori
```
**Check folder contents using the tree command**

```
tree sbongori/
```
---

**Other ways to retrieve genome data:**

1\. Single accession 

*Shiguella sonnei* reference genome

```
datasets download genome accession GCF_002950395.1
```

2\. List of accessions

The list of accessions must be a plain text file, with one accession per line. Example:

```
cat acc.list 

GCF_003710245.1
GCF_000164865.1
GCF_900604315.1
GCF_022647505.1
GCF_010131535.1
GCF_008710095.1
GCF_020268605.1
GCF_900343015.1
GCF_900343025.1
GCF_013460135.1
```

```
datasets download genome accession --inputfile acc.list
```

3\. List of taxa

Similar to the accession list, the list of taxa should be formatted as plain text file, with one taxon per line. We recommend using the NCBI TaxID when retrieving data by taxon to avoid any issues with duplicate or ambiguous names.

```
cat taxid.txt

2762229
351671
2926470
472834
1081631
539813
497725
2918802
83655
2816250
1082704
2741499
3163327
3025875
2675776
2060068
2939450
796334
2027290
69220
```

```
datasets summary genome taxon --inputfile taxid.txt
```

### 2.2. Downloading a big genome data package

Now let's say that you actually need to download all *Salmonella* genome sequences, which amounts to more than half million sequences. Or maybe something smaller, like *Salmonella enterica* subsp. *diarizonae*, which has almost 1,000 genomes. You *can* download it directly, but that's not our recommendation. The *datasets* CLI has the option of downloading *dehydrated* genome packages.  

A dehydrated package doesn't include any data. It has a file (`fetch.txt`) that holds the location information of the requested data files. To retrieve those files, the option *rehydrate* is invoked on the CLI and the files are retrieved. 

**Advantages of rehydration:**

* It's faster than a regular download (it doesn't look like much in this case, but when you're dealing with 500x more sequences, that makes a difference)

|                                   | Salmonella enterica subsp. diarizonae (975 genomes, taxid 59204) |
|-----------------------------------|:-----------------------------------------------------:|
| Regular download                  | ~ 3 minutes                                           |
| Dehydrated download + rehydration | 5 seconds + 60 seconds                                |


* It allows users to download the files as gzip during rehydration, thus taking up less storage space;
* It can be resumed (instead of having to restart in case of failure);
* The `fetch.txt` file can be shared, so you can potentially share your data with other collaborators without having to put hundreds of gigabytes of data on a sharing platform;


**Download a dehydrated package with *Salmonella enterica* subsp. *diarizonae* (taxid 59204) genome and GFF3 files**

```
datasets download genome taxon 59204 --dehydrated --include genome,gff3 --filename 59204-dehydrated.zip
```

Let's unzip and explore the package contents, and compare it to the previous package we downloaded before.


```
unzip 59204-dehydrated.zip -d 59204

Archive:  59204-dehydrated.zip
  inflating: 59204/README.md         
  inflating: 59204/ncbi_dataset/data/assembly_data_report.jsonl  
  inflating: 59204/ncbi_dataset/fetch.txt  
  inflating: 59204/ncbi_dataset/data/dataset_catalog.json  
  inflating: 59204/md5sum.txt        
 
```

As we can see, instead of all the files in their respective folders, we have a file called `fetch.txt`. Let's take a quick look at it:


```
head 59204/ncbi_dataset/fetch.txt 


https://api.ncbi.nlm.nih.gov/datasets/fetch_h/R2V0UmVtb3RlRGF0YWZpbGU/eNqTyufKzUtOytROKymw0tdPT83Lz00t1k_MydF3d3bUNzAw1DcyN9M3tzQF8eOBfCAXyNMzjHcM9oVwygzxycWDzcxM1kvLS9RLrzJgtGAEAH8lH-E      0       data/GCA_001276795.1/GCA_001276795.1_ASM127679v1_genomic.fna
https://api.ncbi.nlm.nih.gov/datasets/fetch_h/R2V0UmVtb3RlRGF0YWZpbGU/eNqTyufKzUtOytROKymw0tdPT83Lz00t1k_MydF3d3bUNzAw1DcyN9O3MDcF8eOBfCAXyNMzjHcM9oVwygzxycWDzcxM1kvLS9RLrzJgtGAEAH4zH9w      0       data/GCA_001276875.1/GCA_001276875.1_ASM127687v1_genomic.fna
https://api.ncbi.nlm.nih.gov/datasets/fetch_h/R2V0UmVtb3RlRGF0YWZpbGU/eNqTyufKzUtOytROKymw0tdPT83Lz00t1k_MydF3d3bUNzAw1DczstA3NzUF8eOBfCAXyNMzjHcM9oVwygzxycWDzcxM1kvLS9RLrzJgtGAEAHxaH9I      0       data/GCA_001628755.1/GCA_001628755.1_ASM162875v1_genomic.fna
https://api.ncbi.nlm.nih.gov/datasets/fetch_h/R2V0UmVtb3RlRGF0YWZpbGU/eNqTyufKzUtOytROKymw0tdPT83Lz00t1k_MydF3d3bUNzAw1DczstA3NzUF8eOBfCAXyNMzjHcM9oVwygzxycWDzcxM1ktPS9NLrzJgtGAEAHxEH9A      0       data/GCA_001628755.1/genomic.gff
https://api.ncbi.nlm.nih.gov/datasets/fetch_h/R2V0UmVtb3RlRGF0YWZpbGU/eNqTyufKzUtOytROKymw0tdPT83Lz00t1k_MydF3d3bUNzAw1DczstQ3NzUF8eOBfCAXyNMzjHcM9oVwygzxycWDzcxM1kvLS9RLrzJgtGAEAH1cH9c      0       data/GCA_001629755.1/GCA_001629755.1_ASM162975v1_genomic.fna
https://api.ncbi.nlm.nih.gov/datasets/fetch_h/R2V0UmVtb3RlRGF0YWZpbGU/eNqTyufKzUtOytROKymw0tdPT83Lz00t1k_MydF3d3bUNzAw1DczstQ3NzUF8eOBfCAXyNMzjHcM9oVwygzxycWDzcxM1ktPS9NLrzJgtGAEAH1GH9U      0       data/GCA_001629755.1/genomic.gff
https://api.ncbi.nlm.nih.gov/datasets/fetch_h/R2V0UmVtb3RlRGF0YWZpbGU/eNqTyufKzUtOytROKymw0tdPT83Lz00t1k_MydF3d3bUNzAw1DczstQ3NzcF8eOBfCAXyNMzjHcM9oVwygzxycWDzcxM1kvLS9RLrzJgtGAEAH9KH-E      0       data/GCA_001629775.1/GCA_001629775.1_ASM162977v1_genomic.fna
https://api.ncbi.nlm.nih.gov/datasets/fetch_h/R2V0UmVtb3RlRGF0YWZpbGU/eNqTyufKzUtOytROKymw0tdPT83Lz00t1k_MydF3d3bUNzAw1DczstQ3NzcF8eOBfCAXyNMzjHcM9oVwygzxycWDzcxM1ktPS9NLrzJgtGAEAH80H98      0       data/GCA_001629775.1/genomic.gff
https://api.ncbi.nlm.nih.gov/datasets/fetch_h/R2V0UmVtb3RlRGF0YWZpbGU/eNqTyufKzUtOytROKymw0tdPT83Lz00t1k_MydF3d3bUNzAw0je3NNE3MTQF8eOBfCAXyNMzjHcM9oVwygzxycWDzcxM1kvLS9RLrzJgtGAEAHrRH8g      0       data/GCA_002794415.1/GCA_002794415.1_ASM279441v1_genomic.fna
https://api.ncbi.nlm.nih.gov/datasets/fetch_h/R2V0UmVtb3RlRGF0YWZpbGU/eNqTyufKzUtOytROKymw0tdPT83Lz00t1k_MydF3d3bUNzAw0je3NNE3MTQF8eOBfCAXyNMzjHcM9oVwygzxycWDzcxM1ktPS9NLrzJgtGAEAHq7H8Y      0       data/GCA_002794415.1/genomic.gff

```

Let's take a closer look at the third column (using the command `cut -f3`):

```
head 59204/ncbi_dataset/fetch.txt | cut -f3


data/GCA_001276795.1/GCA_001276795.1_ASM127679v1_genomic.fna
data/GCA_001276875.1/GCA_001276875.1_ASM127687v1_genomic.fna
data/GCA_001628755.1/GCA_001628755.1_ASM162875v1_genomic.fna
data/GCA_001628755.1/genomic.gff
data/GCA_001629755.1/GCA_001629755.1_ASM162975v1_genomic.fna
data/GCA_001629755.1/genomic.gff
data/GCA_001629775.1/GCA_001629775.1_ASM162977v1_genomic.fna
data/GCA_001629775.1/genomic.gff
data/GCA_002794415.1/GCA_002794415.1_ASM279441v1_genomic.fna
data/GCA_002794415.1/genomic.gff
```
Here we can see:  

- Available files to be retrieved
- Where the files will be downloaded 

During rehydration, users can filter which files they want to download by string matching. Let's take a look at the `rehydrate` subcommand help menu:

```
datasets rehydrate --help

Download data files for an unzipped, dehydrated genome data package. Data files specified in fetch.txt will be downloaded from NCBI. Read more about how rehydration can help with large genome downloads: https://www.ncbi.nlm.nih.gov/datasets/docs/v2/how-tos/genomes/large-download/

Usage
  datasets rehydrate [flags] --directory <directory_name>

Flags
      --directory string   Specify the directory containing the unzipped dehydrated bag
      --gzip               rehydrate files to gzip format
      --list               List files that would be downloaded during rehydration
      --match string       Specify substring that matches files for rehydration
      --max-workers int    Limit the maximum number of concurrent download workers (allowed range is 1-30) (default 10)
      --no-progressbar     Hide progress bar


Global Flags
      --api-key string   Specify an NCBI API key
      --debug            Emit debugging info
      --help             Print detailed help about a datasets command
      --version          Print version of datasets
```

So, let's say that first we want to download only the GFF3 files. Here's how we would build this command: 


datasets		# calls the datasets program
rehydrate		# calls the rehydrate subcommand
--directory		# specifies the directory where the folder ncbi_dataset is.
--match			# matches the name of the files to be rehYDrated.
--list			# shows which files WILL be downloaded
| head			# pipe the output to the command head, which prints the first ten lines.


Let's put it all together now:  

```
datasets rehydrate --directory 59204 --match gff --list | head

data/GCA_001628755.1/genomic.gff
data/GCA_001629755.1/genomic.gff
data/GCA_001629775.1/genomic.gff
data/GCA_002794415.1/genomic.gff
data/GCA_003869275.1/genomic.gff
data/GCA_003872565.2/genomic.gff
data/GCA_003873915.1/genomic.gff
data/GCA_003878075.1/genomic.gff
data/GCA_003878095.1/genomic.gff
data/GCA_003879695.1/genomic.gff
```

---


**Try it yourself:**
 
-  What would happen if you ran the same command without the `--match` flag?   
-  How can you download only the genomic FASTA files and none of the GFF3?

---


### 2.3. Retrieving and filtering metadata information

Back to the *Salmonella bongori* genome data package we downloaded: in addition to the sequence and annotation data, NCBI Datasets **always** includes metadata reports with the data packages. Each data package type (genome, gene, virus, taxonomy) will have a specific data report in JSON or JSON-Lines format. 

Let's take a look inside the data package using the command `tree`. From the main folder, type:

```
tree sbongori
```

Look for the files `assembly_data_report.jsonl` and `dataset_catalog.json`. The first one has all the main metadata information about the sequences included in the data package. The `dataset_catalog.json` lists all files included in the data package, accession numbers, size abd type. Below we have an excerpt of the data catalog:

```
{
  "apiVersion": "V2",
  "assemblies": [
    {
      "files": [
        {
          "filePath": "assembly_data_report.jsonl",
          "fileType": "DATA_REPORT",
          "uncompressedLengthBytes": "575780"
        }
      ]
    },
    {
      "accession": "GCA_000252995.1",
      "files": [
        {
          "filePath": "GCA_000252995.1/GCA_000252995.1_ASM25299v1_genomic.fna",
          "fileType": "GENOMIC_NUCLEOTIDE_FASTA",
          "uncompressedLengthBytes": "4515948"
        }
      ]
    },
   
```


Another way of retrieving metadata information using the *datasets* CLI is to use the `summary` command. The summary command prints the metadata report in JSON format to the screen. Let's try the command below without the `| jq .` and then with it. 


```
datasets summary genome taxon "salmonella bongori"  --reference | jq .
```


**Extracting specific metadata fields from the reports**

Sometimes, we are interested in only a specific piece of metadata information about the species we are studying. For example, if we want to generate a table with only the CheckM quality scores for all samples available for that species, we could use the *dataformat* CLI. *dataformat* has specific schemas for each type of metadata reports, and can be used to convert JSON-Lines to TSV or excel formats.

<div style="text-align: center;">
<img src="https://github.com/ncbi/workshop-asm-big-2026/blob/9d026150ac4beaeb3daef03c20d71e8084e8cf40/datasets/images/dataformat.png" alt="dataformat" style="width: 500px;">
</div>

Let's take a look at the help menu:

```
dataformat tsv genome --help
```

Now let's generate a TSV of all *Salmonella bongori* genomes with the following information:  

- Accession
- Best ANI match
- Scaffold N50
- CheckM completeness
- CheckM contamination

```
datasets summary genome taxon 54736 --as-json-lines | \
dataformat tsv genome \
--fields accession,ani-best-ani-match-organism,assmstats-scaffold-n50,checkm-completeness,checkm-contamination | column -ts $'\t'

Assembly Accession  ANI Best ANI match Organism  Assembly Stats Scaffold N50  CheckM completeness  CheckM contamination
GCF_002035285.1     Salmonella bongori                                        99.61                1.29
GCF_002035475.1     Salmonella bongori                                        99.48                0.82
GCF_002119365.1     Salmonella bongori                                        99.5                 1.04
GCF_003448395.1     Salmonella bongori           112432                       99.33                0.87
GCF_003497195.1     Salmonella bongori           116904                       97.76                1.08
GCF_003521435.1     Salmonella bongori           103793                       96.43                0.78
GCF_003521525.1     Salmonella bongori           196552                       98.99                0.64
GCF_003522735.1     Salmonella bongori           358514                       98.59                0.64
GCF_006051015.1     Salmonella bongori           4476215                      98.5                 0.93
GCF_006051555.1     Salmonella bongori           351113                       99.61                0.88
GCF_006113225.1     Salmonella bongori           4487548                      99.53                0.71
GCF_007019345.1     Salmonella bongori           369720                       99.5                 2.34
GCF_016653555.1     Salmonella bongori           4459441                      99.61                0.64
GCF_019356415.1     Salmonella bongori           4440439                      99.27                0.77
GCF_900635485.1     Salmonella bongori           4466174                      42.81                0.58
...

```

You can save this output and look at the results in the program of your preference. To save the output, you would redirect it to a file, like this:

```
datasets summary genome taxon "salmonella bongori" --as-json-lines | \
dataformat tsv genome \
--fields accession,ani-best-ani-match-organism,assmstats-scaffold-n50,checkm-completeness,checkm-contamination > sbongori_stats.tsv
```

**Exercise**

Could you generate the same output we did using the `summary` command by using the  *Salmonella bongori* genome data package instead?

---

<details>

<summary>Exploring metadata files in the data package</summary>

This can be done in two different ways:

1. Using the zipped data package as input

```
dataformat tsv genome --package 54736.zip \
--fields accession,ani-best-ani-match-organism,assmstats-scaffold-n50,checkm-completeness,checkm-contamination | column -ts $'\t'
   
```

2. Pointing to the specific report in the unzipped data package:

```
dataformat tsv genome --inputfile sbongori/ncbi_dataset/data/assembly_data_report.jsonl \
--fields accession,ani-best-ani-match-organism,assmstats-scaffold-n50,checkm-completeness,checkm-contamination | column -ts $'\t'
   
```

</details>

---

## 3. Retrieving Virus information using NCBI Datasets

Users can retrieve viral genome sequences and metadata using the Virus service from NCBI Datasets CLI. 

**What's the difference between the Virus and Genome endpoints in Datasets?**

The data available through the Datasets Virus and Genome endpoints originate from **GenBank** but combine data from distinct selection and curation processes. Virus data is sourced from NCBI Virus, which employs both manual and automated curation processes to normalize every viral sequence provided by the International Nucleotide Sequence Database Collaboration (INSDC) and to standardize metadata. NCBI Datasets Genome endpoint provides access to **RefSeqs and Assemblies**, including a subset of virus sequences, which have been designated as RefSeqs or genome groups for segmented viruses, represented as NCBI Assemblies with accessions GCF\_/GCA\_, respectively.

**What does it mean for those working on viruses?**

- Data packages downloaded from Virus endpoint will be different from those downloaded from the Genome endpoint;
- Use the Virus endpoint to access all available virus sequences including complete and partial ones; 


### 3.1. Special virus cases: cache packages for SARS-CoV-2 and Influenza

For both SARS-CoV-2 and (Alpha)Influenza, NCBI Datasets CLI provides a cache package. A cache package is pre-packaged with all genomes available for those two taxa. 

An cache package is the equivalent to a grab-n-go sandwich versus a made-to-order one (regular packages). It's faster to download a cache package because it doesn't need to be assembled, but it also travels through faster download channels at NCBI.

- Let's take a look at the options for the virus genome subcommand:

```
datasets download virus genome taxon --help


Download a virus genome data package by taxon (NCBI Taxonomy ID, scientific or common name for any virus at any tax rank). Virus genome data packages include genome, transcript and protein sequences, annotation and one or more data reports. Data packages are downloaded as a zip archive.

The default virus genome data package includes the following files:
  * genomic.fna (genomic sequences)
  * data_report.jsonl (data report with virus genome metadata)
  * dataset_catalog.json (a list of files and file types included in the data package)

Usage
  datasets download virus genome taxon  <taxon> [flags]

Sample Commands
  datasets download virus genome taxon sars-cov-2 --host dog --include protein
  datasets download virus genome taxon coronaviridae --host "manis javanica"

Flags
      --fast-zip-validation   Skip zip checksum validation after download
      --inputfile string      Read a list of NCBI taxonomy identifiers (taxid or current scientific name) from a file to use as input (max: 100)


Global Flags
      --annotated                 Limit to annotated genomes
      --api-key string            Specify an NCBI API key
      --complete-only             Limit to complete sequences, as defined by submitter
      --debug                     Emit debugging info
      --filename string           Specify a custom file name for the downloaded data package (default "ncbi_dataset.zip")
      --geo-location string       Limit to genomes isolated from a specified geographic location (continent or country)
      --help                      Print detailed help about a datasets command
      --host string               Limit to virus genomes isolated from a specified host species
      --include string(,string)   Specify virus genome sequence types to download
                                    * genome:     genomic sequences
                                    * cds:        nucleotide coding sequences
                                    * protein:    amino acid sequences
                                    * annotation: annotation report
                                    * biosample:  biosample report
                                    * none:       no sequence data, only primary data report
                                       (default [genome])
      --lineage string            Limit results by Pango lineage (only SARS-CoV-2)
      --no-progressbar            Hide progress bar
      --refseq                    Limit to RefSeq genomes
      --released-after string     Limit to genomes released on or after a specified date (free format, ISO 8601 YYYY-MM-DD recommended)
      --updated-after string      Limit to genomes updated on or after a specified date (free format, ISO 8601 YYYY-MM-DD recommended)
      --usa-state string          Limit to genomes isolated from a specified U.S. state (two-letter abbreviation)
      --version                   Print version of datasets
```



### 3.2. Retrieving genome information for Dengue virus

In this exercise, we will take a look at the genomes available for the Dengue virus. 

Dengue Virus (taxid 12637; ~ 57k genomes)

- Download all genomes

```
datasets download virus genome taxon 12637 --filename dengue-all.zip
```

- Download reference (4 genomes, Dengue virus 1-4)

```
datasets download virus genome taxon 12637 --refseq --filename dengue-all-ref.zip
```

### 3.3. Filtering based on metadata information

- Look at the first record and all the fields with `jq`

```
datasets summary virus genome taxon 12637 --limit 1 | jq
```

- Use dataformat to pull metadata information. Let's look at unique entries for the geo-location field. 
   - `datasets` will retrieve the metadata;
   - `dataformat` will pull the information from the metadata field `geo-location`
   - `sort` will sort all the `geo-location` entries in alphabetical order
   - `uniq -c` will count the number of each unique entry

```
datasets summary virus genome taxon 12637 --as-json-lines | \
dataformat tsv virus-genome --fields geo-location | sort | uniq -c

```


- Let's look at all genomes filtered by geo-location (Brazil)

```
datasets summary virus genome taxon 12637 --geo-location Brazil | jq .total_count
```

- We have anotheer field to filter by US state that's separate from the `--geo-location` flag. Let's take a look at how many genomes we have from Florida using the `summary` subcommand and `jq`:

```
datasets summary virus genome taxon 12637 --usa-state FL | jq .total_count
```



----
## 4. Important resources

- ASM-BIG Github (for the CLI tutorial): [https://github.com/ncbi/workshop-asm-big-2026](https://github.com/ncbi/workshop-asm-big-2026)


**NCBI Datasets main resources**

- NCBI Datasets homepage: [https://www.ncbi.nlm.nih.gov/datasets/](https://www.ncbi.nlm.nih.gov/datasets/)
- Github: [https://github.com/ncbi/datasets](https://github.com/ncbi/datasets)


**Download and installation instructions (CLI)**

- Instructions:  
 [https://www.ncbi.nlm.nih.gov/datasets/docs/v2/download-and-install/](https://www.ncbi.nlm.nih.gov/datasets/docs/v2/download-and-install/)
  
**Tutorials, how-to guides and past workshops**
 
- How-to guides (short, one-line CLI tasks):   
[https://www.ncbi.nlm.nih.gov/datasets/docs/v2/how-tos/](https://www.ncbi.nlm.nih.gov/datasets/docs/v2/how-tos/)
- Tutorials (multi-task, longer tutorials, mostly based on feedback or questions we get from users): [https://www.ncbi.nlm.nih.gov/datasets/docs/v2/tutorials/](https://www.ncbi.nlm.nih.gov/datasets/docs/v2/tutorials/)
- Past training sessions and workshops (Jupyter notebooks used in previous *datasets* training events): [https://github.com/ncbi/datasets/tree/master/training](https://github.com/ncbi/datasets/tree/master/training)

**How to get help**

- Email the helpdesk: [info@ncbi.nlm.nih.gov](mailto:info@ncbi.nlm.nih.gov)
- Github: [https://github.com/ncbi/datasets](https://github.com/ncbi/datasets)
- Yellow feedback button on our pages 

---

