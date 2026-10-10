# Retrieving Genomic Data and Metadata Using the NCBI Datasets Command-Line Tool

[NCBI Datasets](https://www.ncbi.nlm.nih.gov/datasets/) is a resource that allows users to download data and metadata from [API](https://www.ncbi.nlm.nih.gov/datasets/docs/v2/reference-docs/rest-api/), [web](https://www.ncbi.nlm.nih.gov/datasets/) and [command-line tool](https://www.ncbi.nlm.nih.gov/datasets/docs/v2/download-and-install/). In this workshop, we will be focusing on the command-line tool, its structure and organization.

<div style="text-align: center;">
   <img src="https://www.ncbi.nlm.nih.gov/datasets/docs/v2/datasets_getting_started.png" alt="getting-started" style="width: 800px;">
</div>

## 1. NCBI Datasets Command-line tools: *datasets* and *dataformat*

While the web interface is helpful, there are times when it's more convenient to access genomes through a command-line environment. For example, let's say you are working on your institution's high-performance computing (HPC) system and you need to download dozens (or hundreds of genomes). Even if you're using the Datasets web interface, this would potentially be a two step process:

1. Download the genome data package locally;
2. Transfer the files to the HPC system.

With the NCBI Datasets command-line interface (CLI), you can do this process in a single step. Our CLI allows users to access not only genomes, but also genes, ortholog sets and virus genomes.

In this virtual machine, we have the necessary tools installed for you to explore NCBI Datasets without the need to configure anything. When you decide to use NCBI Datasets on your own machine or HPC system, you need to install it. More information on how to install NCBI Datasets can be found in [our documentation page](https://www.ncbi.nlm.nih.gov/datasets/docs/v2/download-and-install/).

### Building a *datasets* CLI command

The NCBI Datasets CLI command structure is very intuitive. If you take a look at the diagram below, you will notice that the commands are built by choosing one option from each vertical rectangle.

<div style="text-align: center;">
<img src="https://raw.githubusercontent.com/ncbi/workshop-asm-big-2026/refs/heads/main/datasets/images/command-choice.png" alt="commands" style="width: 700px;">
</div>

#### Basic commands

<div style="border-left: 4px solid #1a7f37; padding: 12px 16px;">

<p>💡 <strong>Steps:</strong></p>
<p><strong>Step 1. What would you like to do?</strong></p>

<table style="margin-left:0; text-align:left !important;">
  <thead>
    <tr>
      <th style="text-align:left !important;">Action</th>
      <th style="text-align:right !important;">CLI option</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:left !important;">Download sequence data and metadata as a zip package</td>
      <td style="text-align:right !important;"><code>download</code></td>
    </tr>
    <tr>
      <td style="text-align:left !important;">Retrieve metadata as JSON output</td>
      <td style="text-align:right !important;"><code>summary</code></td>
    </tr>
    <tr>
      <td style="text-align:left !important;">Rehydrate a dehydrated data package</td>
      <td style="text-align:right !important;"><code>rehydrate</code></td>
    </tr>
  </tbody>
</table>

<hr>

<p><strong>Step 2. What kind of data would you like to retrieve?</strong></p>

<table style="margin-left:0; text-align:left !important;">
  <thead>
    <tr>
      <th style="text-align:left !important;">Data type</th>
      <th style="text-align:right !important;">CLI option</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:left !important;">Genome assemblies, annotation files, and assembly metadata</td>
      <td style="text-align:right !important;"><code>genome</code></td>
    </tr>
    <tr>
      <td style="text-align:left !important;">Gene, transcript, and protein sequences and metadata</td>
      <td style="text-align:right !important;"><code>gene</code></td>
    </tr>
    <tr>
      <td style="text-align:left !important;">Viral genome and protein sequences and metadata</td>
      <td style="text-align:right !important;"><code>virus</code></td>
    </tr>
    <tr>
      <td style="text-align:left !important;">Taxonomic classification and naming metadata</td>
      <td style="text-align:right !important;"><code>taxonomy</code></td>
    </tr>
  </tbody>
</table>

<hr>

<p><strong>Step 3. What input information do you have?</strong></p>

<table style="margin-left:0; text-align:left !important;">
  <thead>
    <tr>
      <th style="text-align:left !important;">Description</th>
      <th style="text-align:left !important;">Example</th>
      <th style="text-align:left !important;">CLI option</th>
      <th style="text-align:center !important;">genome</th>
      <th style="text-align:center !important;">gene</th>
      <th style="text-align:center !important;">virus</th>
      <th style="text-align:center !important;">taxonomy</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:left !important;">NCBI Assembly accession</td>
      <td style="text-align:left !important;"><code>GCF_000001405.40</code></td>
      <td style="text-align:left !important;"><code>accession</code></td>
      <td style="text-align:center !important;">x</td>
      <td style="text-align:left !important;"></td>
      <td style="text-align:left !important;"></td>
      <td style="text-align:left !important;"></td>
    </tr>
    <tr>
      <td style="text-align:left !important;">BioProject accession</td>
      <td style="text-align:left !important;"><code>PRJNA763586</code></td>
      <td style="text-align:left !important;"><code>accession</code></td>
      <td style="text-align:center !important;">x</td>
      <td style="text-align:left !important;"></td>
      <td style="text-align:left !important;"></td>
      <td style="text-align:left !important;"></td>
    </tr>
    <tr>
      <td style="text-align:left !important;">RefSeq nucleotide accession</td>
      <td style="text-align:left !important;"><code>NM_000546.6</code></td>
      <td style="text-align:left !important;"><code>accession</code></td>
      <td style="text-align:left !important;"></td>
      <td style="text-align:center !important;">x</td>
      <td style="text-align:left !important;"></td>
      <td style="text-align:left !important;"></td>
    </tr>
    <tr>
      <td style="text-align:left !important;">RefSeq protein accession</td>
      <td style="text-align:left !important;"><code>NP_000537.3</code></td>
      <td style="text-align:left !important;"><code>accession</code></td>
      <td style="text-align:left !important;"></td>
      <td style="text-align:center !important;">x</td>
      <td style="text-align:left !important;"></td>
      <td style="text-align:left !important;"></td>
    </tr>
    <tr>
      <td style="text-align:left !important;">Virus nucleotide accession</td>
      <td style="text-align:left !important;"><code>NC_045512.2</code></td>
      <td style="text-align:left !important;"><code>accession</code></td>
      <td style="text-align:left !important;"></td>
      <td style="text-align:left !important;"></td>
      <td style="text-align:center !important;">x</td>
      <td style="text-align:left !important;"></td>
    </tr>
    <tr>
      <td style="text-align:left !important;">NCBI taxonomy ID, scientific or common name</td>
      <td style="text-align:left !important;"><code>9606</code>, <code>Homo sapiens</code>, <code>human</code></td>
      <td style="text-align:left !important;"><code>taxon</code></td>
      <td style="text-align:center !important;">x</td>
      <td style="text-align:center !important;">x</td>
      <td style="text-align:center !important;">x</td>
      <td style="text-align:center !important;">x</td>
    </tr>
    <tr>
      <td style="text-align:left !important;">NCBI Gene ID</td>
      <td style="text-align:left !important;"><code>672</code></td>
      <td style="text-align:left !important;"><code>gene-id</code></td>
      <td style="text-align:left !important;"></td>
      <td style="text-align:center !important;">x</td>
      <td style="text-align:left !important;"></td>
      <td style="text-align:left !important;"></td>
    </tr>
    <tr>
      <td style="text-align:left !important;">Gene symbol</td>
      <td style="text-align:left !important;"><code>tp53</code></td>
      <td style="text-align:left !important;"><code>symbol</code></td>
      <td style="text-align:left !important;"></td>
      <td style="text-align:center !important;">x</td>
      <td style="text-align:left !important;"></td>
      <td style="text-align:left !important;"></td>
    </tr>
    <tr>
      <td style="text-align:left !important;">Gene locus tag</td>
      <td style="text-align:left !important;"><code>b0001</code></td>
      <td style="text-align:left !important;"><code>locus-tag</code></td>
      <td style="text-align:left !important;"></td>
      <td style="text-align:center !important;">x</td>
      <td style="text-align:left !important;"></td>
      <td style="text-align:left !important;"></td>
    </tr>
    <tr>
      <td style="text-align:left !important;">SARS-CoV-2 protein name</td>
      <td style="text-align:left !important;"><code>S</code>, <code>ORF1ab</code>, <code>nsp1</code></td>
      <td style="text-align:left !important;"><code>protein</code></td>
      <td style="text-align:left !important;"></td>
      <td style="text-align:left !important;"></td>
      <td style="text-align:center !important;">x</td>
      <td style="text-align:left !important;"></td>
    </tr>
  </tbody>
</table>
</div>

#### Flags

In addition to the program commands, *datasets* has a number of flags available for filtering the results. In this workshop, we will focus on genome retrieval, so I'll use those flags as example. All this information can be found by using the `--help` flag in combination with any command.

<div style="border-left: 4px solid #1a7f37; padding: 12px 16px;">
<table style="margin-left:0; text-align:left !important;">
  <thead>
    <tr>
      <th style="text-align:left !important;">Questions and filters</th>
      <th style="text-align:right !important;">Flag</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:left !important;">I want to download only <b>annotated</b> genomes</td>
      <td style="text-align:right !important;"><code>--annotated</code></td>
    </tr>
    <tr>
      <td style="text-align:left !important; word-wrap:break-word;">I want to download the <b>best genome</b> available for my taxon of interest</td>
      <td style="text-align:right !important;"><code>--reference</code></td>
    </tr>
    <tr>
      <td style="text-align:left !important;">How can I download a <b>list of assembly accessions</b> from a publication?</td>
      <td style="text-align:right !important;"><code>--inputfile list.txt</code></td>
    </tr>
    <tr>
      <td style="text-align:left !important;">How can I choose only <b>RefSeq</b> genome assemblies?</td>
      <td style="text-align:right !important;"><code>--assembly-source refseq</code></td>
    </tr>
    <tr>
      <td style="text-align:left !important;">How can I download <b>different filetypes?</b></td>
      <td style="text-align:right !important;"><code>--include genome,cds</code></td>
    </tr>
     <tr>
      <td style="text-align:left !important;">Can I download only <b>chromosome level</b> assemblies from <b>type specimens</b>?</td>
      <td style="text-align:right !important;"><code>--assembly-level chromosome<br>--from-type</code></td>
    </tr>
    <tr>
      <td style="text-align:left !important;">I want to exclude MAGs from my download</td>
      <td style="text-align:right !important;"><code>--mag exclude</code></td>
    </tr>
  </tbody>
</table>
</div>

<br>


**ADDENDUM: GCA versus GCF**

<div style="text-align: left;">
   <img src="https://www.ncbi.nlm.nih.gov/datasets/docs/v2/images/gcf_vs_gca_v9.png" alt="GCA-GCF" style="width: 600px;">
</div>

**Now it's your turn!**

<div style="border-left: 4px solid #8250df; background-color:#faf5ff; padding:12px 16px;">

<p>💻 <strong>Let's work together</strong></p>

<p>Build a <i>datasets</i> command to explore the <b>metadata</b> for <i>Salmonella bongori</i>, taxid: 54736. We will look at the tables and build the base command together.</p>

<p>1. How many genome assemblies are available for this taxon?<br>🧩<i>Hint: check the field <code>total_count</code> at the bottom of the screen output</i>.</p>
<p>2. How many RefSeq genome assemblies?</p>
<p><strong>BONUS</strong> How many genome assemblies were released on or after January 01, 2026?<br>🧩<i>Hint</i>: use the <code>--help</code> flag to find the right option to use.</p>

</div>

<br>

In addition to *datasets*, we also have *dataformat*, a companion tool to explore and convert metadata to TSV or Excel formats. We will cover the *dataformat* command syntax and use in the metadata section below.

## 2. Retrieving bacterial data and metadata using *datasets*

Bacteria is the taxonomic group with the largest number of available genomes - no surprises here. Currently there are 3.38 million bacterial genomes (on 10/08/2026), with *Salmonella* being the most represented taxon (> 637,000 genome sequences).

As expected, retrieving such a large number of genome sequences is a challenging task. In this workshop, we will show some strategies to potentially improve your download experience and data retrieval from NCBI using *datasets*.

### 2.1. Downloading a "small" genome data package

Small and large are very relative terms. When thinking about genome projects, that answer also can vary depending on the taxon in question. If we consider genome size, a project that aims to evaluate 1000 human genomes will involve roughly 3,100 Gb, while the same concept (1,000 genomes) for an average bacterial genome (around 5 Mb) will entail only 5 Gb, which is 620 times less data. In addition to the storage space, we should also consider the network over which the download is happening: if your network is not very fast or reliable, you would benefit from using an option that allows for downloads to be resumed and that can handle slower speeds.

<div style="border-left: 4px solid #8250df; background-color:#faf5ff; padding:12px 16px;">

<p>💻 <strong>Let's work together</strong></p>

<p>For our small example, let's look again into <i>Salmonella bongori</i>. We will <strong>download</strong> a default genome data package for this species.</p>

<p><strong>Download <i>S. bongori</i> genomes by taxid:</strong></p>

<p><code>datasets download genome taxon 54736 --filename 54736.zip</code></p>

<p><strong>Unzip the package and inspect the folder structure and contents</strong></p>

<p><code>unzip 54736.zip -d sbongori</code></p>

<p><strong>Check folder contents using the <code>tree</code> command</strong></p>

<p><code>tree sbongori/</code></p>

</div>

**Other ways to retrieve genome data:**

<details>
<summary><strong>1. Single accession</strong></summary>
<br>

*Shigella sonnei* reference genome

```
datasets download genome accession GCF_002950395.1
```
<br>

</details>

<details>
<summary><strong>2. List of accessions</strong></summary>
<br>

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
<br>

</details>

<details>
<summary><strong>3. List of taxa</strong></summary>
<br>

Similar to the accession list, the list of taxa should be formatted as a plain text file, with one taxon per line. We recommend using the NCBI TaxID when retrieving data by taxon to avoid any issues with duplicate or ambiguous names.

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
<br>

</details>

---

### 2.2. Downloading a big genome data package

Now let's say that you actually need to download all *Salmonella* genome sequences, which amounts to more than 600 million sequences. Or maybe something smaller, like *Salmonella enterica* subsp. *diarizonae*, which has almost 1,000 genomes. You *can* download it directly, but that's not our recommendation. The *datasets* CLI has the option of downloading *dehydrated* genome packages.

A dehydrated package doesn't include any data. It has a file (`fetch.txt`) that holds the location information of the requested data files. To retrieve those files, the option *rehydrate* is invoked on the CLI and the files are retrieved.

<div style="border-left: 4px solid #1a7f37; padding: 12px 16px;">
<p>💡 <strong>Advantages of rehydration</strong></p>
<ul>
<li>It's faster than a regular download (it doesn't look like much in this case, but when you're dealing with 500x more sequences, that makes a difference)</li>
</ul>

<table style="margin-left:0; text-align:left !important;">
  <thead>
    <tr>
      <th style="text-align:left !important;"></th>
      <th style="text-align:center !important;">Salmonella enterica subsp. diarizonae (975 genomes, taxid 59204)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:left !important;">Regular download</td>
      <td style="text-align:center !important;">~ 3 minutes</td>
    </tr>
    <tr>
      <td style="text-align:left !important;">Dehydrated download + rehydration</td>
      <td style="text-align:center !important;">5 seconds + 60 seconds</td>
    </tr>
  </tbody>
</table>

<ul>
<li>It allows users to download the files as gzip during rehydration, thus taking up less storage space</li>
<li>It can be resumed (instead of having to restart in case of failure)</li>
<li>The <code>fetch.txt</code> file can be shared, so you can potentially share your data with other collaborators without having to put hundreds of gigabytes of data on a sharing platform</li>
</ul>

</div>

Now let's learn how to download a dehydrated genome data package, understand its structure and contents and choose which data files we want to download.

<div style="border-left: 4px solid #8250df; background-color:#faf5ff; padding:12px 16px;">

<p>💻 <strong>Let's work together</strong></p>

<p>Download a dehydrated package for <i>Salmonella enterica</i> subsp. <i>diarizonae</i> (taxid 59204) with genome FASTA and GFF3 files</p>

<pre><code>datasets download genome taxon 59204 \
--dehydrated --include genome,gff3 --filename 59204-dehydrated.zip
</code></pre>

<p>Let's unzip and explore the package contents, and compare it to the previous package we downloaded before.</p>

<pre><code>
unzip 59204-dehydrated.zip -d 59204

Archive:  59204-dehydrated.zip
  inflating: 59204/README.md         
  inflating: 59204/ncbi_dataset/data/assembly_data_report.jsonl  
  inflating: 59204/ncbi_dataset/fetch.txt  
  inflating: 59204/ncbi_dataset/data/dataset_catalog.json  
  inflating: 59204/md5sum.txt        
</code></pre>

<br>

<details>
<summary><strong>QUESTION: what is different here from the previous data package we downloaded?</strong></summary>
<br>
<ul>
<li>No genomes or GFF3 files were downloaded to the data folder</li>
<li>Extra file: <code>fetch.txt</code></li>
</ul>

<p>As we can see, instead of all the files in their respective folders, we have a file called <code>fetch.txt</code>. Let's take a quick look at its third column (using the UNIX command <code>cut</code>):</p>

<pre><code>head 59204/ncbi_dataset/fetch.txt | cut -f3

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
</code></pre>

<br>

<p>Here we can see:</p>

<ul>
<li>Available files to be retrieved</li>
<li>Where the files will be downloaded</li>
</ul>

</details>

</div>

<br>

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
      --version           Print version of datasets
```

<div style="border-left: 4px solid #8250df; background-color:#faf5ff; padding:12px 16px;">

<p>💻 <strong>Let's work together</strong></p>

<p>So, let's say that first we want to download only the GFF3 files, and we first want to check which files would be downloaded. Here's how we would build this command:</p>

<pre><code>datasets	   	# calls the datasets program
rehydrate		# calls the rehydrate subcommand
--directory		# specifies the directory where the folder ncbi_dataset is.
--match			# matches the name of the files to be rehydrated.
--list			# shows which files WILL be downloaded
| head			# pipe the output to the command head, which prints the first ten lines.
</code></pre>

<br>

<details>
<summary><strong>🧩 Need a hint?</strong></summary>
<br>
<code>datasets rehydrate --directory 59204 --match gff --list | head</code>
<br>
</details>
<br>
<p><b>BONUS QUESTIONS</b></p>

<ul>
<li>What would happen if you ran the same command without the <code>--match</code> flag?</li>
<li>How can you download only the genomic FASTA files and none of the GFF3?</li>
</ul>
<br>
</div>

---

### 2.3. Retrieving and filtering metadata information

<div style="border-left: 4px solid #cf222e; background-color:#fff0f0; padding:12px 16px;">

<p>🛑 <strong>Checkpoint: Before moving on...</strong></p>

<p>Make sure you are in the correct working directory before continuing. Run:</p>

<pre><code>pwd</code></pre>

<br>

<p>You should see something like:</p>

<pre><code>/home/jupyter-your_username/workshop-asm-big-2026/datasets</code></pre>

<br>

<p>If you're not in the right folder, use <code>cd</code> to navigate there before continuing with the next steps.</p>

</div>

<br>

Back to the <i>Salmonella bongori</i> genome data package we downloaded: in addition to the sequence and annotation data, NCBI Datasets <strong>always</strong> includes metadata reports with the data packages. Each data package type (genome, gene, virus, taxonomy) will have a specific data report in JSON or JSON-Lines format.

Let's take a look inside the data package using the command `tree`. From the main folder, type:

```
tree sbongori
```

Look for the files `assembly_data_report.jsonl` and `dataset_catalog.json`. The `assembly_data_report.jsonl` has all the main metadata information about the sequences included in the data package. The `dataset_catalog.json` lists all files included in the data package, accession numbers, size and type. Below we have an excerpt of the main data report (`assembly_data_report.jsonl`):

```
{
  "assemblyInfo": {
    "assemblyLevel": "Complete Genome",
    "assemblyName": "ASM25299v1",
    "assemblyType": "haploid",
    "submitter": "Sanger Institute",
    "refseqCategory": "reference genome",
    "bioprojectLineage": [
      {
        "bioprojects": [
          {
            "accession": "PRJNA351",
            "title": "Reptile-specific Salmonella"
          }
        ]
      }
    ],
```

Another way of retrieving metadata information using the *datasets* CLI is to use the `summary` command. The summary command prints the metadata report in JSON format to the screen.

<div style="border-left: 4px solid #8250df; background-color:#faf5ff; padding:12px 16px;">

<p>💻 <strong>Let's work together</strong></p>

<p>Let's print the <b>metadata</b> information for the <b>reference</b> genome of <i>Salmonella bongori</i>. Try it with and without adding <code>| jq .</code></p>

<details>
<summary><strong>🧩 Need a hint?</strong></summary>
<br>

<code>datasets summary genome taxon "salmonella bongori" --reference</code>
<br>
</details>

</div>

<br>

**Extracting specific metadata fields from the reports**

Sometimes, we are interested in only a specific piece of metadata information about the species we are studying. For example, if we want to generate a table with only the CheckM quality scores for all samples available for that species, we could use the *dataformat* CLI. *dataformat* has specific schemas for each type of metadata reports, and can be used to convert JSON-Lines to TSV or excel formats.

<div style="text-align: center;">
<img src="https://raw.githubusercontent.com/ncbi/workshop-asm-big-2026/refs/heads/main/datasets/images/dataformat.png" alt="dataformat" style="width: 500px;">
</div>

Let's take a look at the help menu:

```
dataformat tsv genome --help
```

<div style="border-left: 4px solid #8250df; background-color:#faf5ff; padding:12px 16px;">

<p>💻 <strong>Let's work together</strong></p>

<p>Now let's generate a TSV of all <i>Salmonella bongori</i> genomes with the following information:</p>

<ul>
<li>Accession</li>
<li>Best ANI match</li>
<li>CheckM completeness</li>
<li>CheckM contamination</li>
</ul>

<pre><code>datasets summary genome taxon 54736 --as-json-lines | dataformat tsv genome --fields accession,ani-best-ani-match-organism,checkm-completeness,checkm-contamination | column -ts $'\t'

Assembly Accession  ANI Best ANI match Organism  CheckM completeness  CheckM contamination
GCF_002035285.1     Salmonella bongori           99.63                1.29
GCF_002035475.1     Salmonella bongori           99.48                0.82
GCF_002119365.1     Salmonella bongori           99.5                 1.1
GCF_003448395.1     Salmonella bongori           99.4                 0.87
GCF_003497195.1     Salmonella bongori           97.76                1.14
GCF_003521435.1     Salmonella bongori           96.43                0.85
GCF_003521525.1     Salmonella bongori           98.99                0.71
GCF_003522735.1     Salmonella bongori           98.59                0.71
GCF_006051015.1     Salmonella bongori           98.5                 0.93
GCF_006051555.1     Salmonella bongori           99.61                0.88
GCF_006113225.1     Salmonella bongori           99.53                0.71
GCF_007019345.1     Salmonella bongori           99.5                 2.41
...
</code></pre>
</div>

You can save this output and look at the results in the program of your preference. To save the output, you would redirect it to a file, like this:

```
datasets summary genome taxon "salmonella bongori" --as-json-lines | dataformat tsv genome --fields accession,ani-best-ani-match-organism,checkm-completeness,checkm-contamination > sbongori_stats.tsv
```

<div style="border-left: 4px solid #8250df; background-color:#faf5ff; padding:12px 16px;">

<p>💻 <strong>Let's work together</strong></p>

<p>Could you generate the same output we did using the <code>summary</code> command by using the data report from the <b>Salmonella bongori</b> genome data package instead?</p>
<br>

This can be done in two different ways:

<details>
<summary><strong>1. Using the zipped data package as input</strong></summary>
<br>

<pre><code>dataformat tsv genome --package 54736.zip --fields accession,ani-best-ani-match-organism,checkm-completeness,checkm-contamination | column -ts $'\t'
</code></pre>

<br>

</details>

<details>
<summary><strong>2. Pointing to the specific report in the unzipped data package:</strong></summary>
<br>

<pre><code>
dataformat tsv genome --inputfile sbongori/ncbi_dataset/data/assembly_data_report.jsonl --fields accession,ani-best-ani-match-organism,checkm-completeness,checkm-contamination | column -ts $'\t'
</code></pre>

<br>

</details>

</div>

---

## 3. Retrieving Virus information using NCBI Datasets

Users can retrieve viral genome sequences and metadata using the Virus service from NCBI Datasets CLI.

**What's the difference between the Virus and Genome endpoints in Datasets?**

The data available through the Datasets Virus and Genome endpoints originate from **GenBank** but combine data from distinct selection and curation processes. Virus data is sourced from NCBI Virus, which employs both manual and automated curation processes to normalize every viral sequence provided by the International Nucleotide Sequence Database Collaboration (INSDC) and to standardize metadata. NCBI Datasets Genome endpoint provides access to **RefSeqs and Assemblies**, including a subset of virus sequences, which have been designated as RefSeqs or genome groups for segmented viruses, represented as NCBI Assemblies with accessions GCF\_/GCA\_, respectively.

**What does it mean for those working on viruses?**

- Data packages downloaded from Virus endpoint will be different from those downloaded from the Genome endpoint;
- Use the Virus endpoint to access all available virus sequences including complete and partial ones;

<div style="border-left: 4px solid #1a7f37; padding: 12px 16px;">

<p>💡 <strong>Special virus cases: cache packages for SARS-CoV-2 and Influenza</strong></p>

<p>For both SARS-CoV-2 and (Alpha)Influenza, NCBI Datasets CLI provides a cache package. A cache package is pre-packaged with all genomes available for those two taxa.</p>

<p>An cache package is the equivalent to a grab-n-go sandwich versus a made-to-order one (regular packages). It's faster to download a cache package because it doesn't need to be assembled, but it also travels through faster download channels at NCBI.</p>

</div>

### 3.1. Retrieving genome information for Dengue virus

In this exercise, we will take a look at the genomes available for the Dengue virus. The Virus endpoint has different filters than the Genome endpoint. Use the `--help` flag to explore the filtering options.

<div style="border-left: 4px solid #8250df; background-color:#faf5ff; padding:12px 16px;">

<p>💻 <strong>Let's work together</strong></p>

<ul>
<li>Download all Dengue virus genomes (taxid 12637; ~ 57k genomes)</li>
</ul>

<pre><code>datasets download virus genome taxon 12637 --filename dengue-all.zip
</code></pre>

<ul>
<li>Download reference genomes (4 genomes, Dengue virus 1-4)</li>
</ul>

<pre><code>datasets download virus genome taxon 12637 --refseq --filename dengue-all-ref.zip
</code></pre>

</div>

### 3.2. Filtering based on metadata information

<div style="border-left: 4px solid #8250df; background-color:#faf5ff; padding:12px 16px;">

<p>💻 <strong>Let's work together</strong></p>

<ul>
<li>Look at the first record and all the fields with <code>jq</code></li>
</ul>

<pre><code>datasets summary virus genome taxon 12637 --limit 1 | jq
</code></pre>

<ul>
<li>Use dataformat to pull metadata information. Let's look at unique entries for the geo-location field.
  <ul>
    <li><code>datasets</code> will retrieve the metadata;</li>
    <li><code>dataformat</code> will pull the information from the metadata field <code>geo-location</code></li>
    <li><code>sort</code> will sort all the <code>geo-location</code> entries in alphabetical order</li>
    <li><code>uniq -c</code> will count the number of each unique entry</li>
  </ul>
</li>
</ul>

<pre><code>datasets summary virus genome taxon 12637 --as-json-lines | dataformat tsv virus-genome --fields geo-location | sort | uniq -c
</code></pre>

<ul>
<li>Let's look at all genomes filtered by geo-location (Brazil)</li>
</ul>

<pre><code>datasets summary virus genome taxon 12637 --geo-location Brazil | jq .total_count
</code></pre>

<ul>
<li>We have another field to filter by US state that's separate from the <code>--geo-location</code> flag. Let's take a look at how many genomes we have from Florida using the <code>summary</code> subcommand and <code>jq</code>:</li>
</ul>

<pre><code>datasets summary virus genome taxon 12637 --usa-state FL | jq .total_count
</code></pre>

</div>

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
