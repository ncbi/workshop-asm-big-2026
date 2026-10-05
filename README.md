# 2026 ASM BIG NCBI workshop

This workshop introduces NCBI resources and tools for exploring microbial genomes, investigating outbreaks, and studying antimicrobial resistance. These hands-on projects combine public sequence data and sample metadata with browser-based exploration and command-line analysis.

## Workshop projects

### Part 1 - NCBI Datasets CLI
1. **[Overview of NCBI Datasets](datasets/datasets.md#ncbi-datasets-an-overview)**
2. **[Retrieving Bacterial data and metadata](datasets/datasets.md#retrieving-bacterial-data-and-metadata-using-datasets)** Download small and large bacterial genome packages using TaxIDs, accessions, and lists of identifiers; extract and export specific metadata fields from JSON/JSON-L to TSV using dataformat.
3. **[Retrieving Virus information](datasets/datasets.md#retrieving-virus-information-using-ncbi-datasets)** Learn how the Virus endpoint differs from the Genome endpoint and how cache packages can be used for retrieval of SARS-CoV-2 and Influenza genomes; download and filter data retrievals by specific metadata fields.

### Part 2 - SRA

### Part 3 - Pathogens

1. **[Outbreak investigation with NCBI Pathogen Detection](outbreak/README.md).** Investigate a clinical _Listeria monocytogenes_ isolate, explore closely related isolates, and use genomic relationships and metadata to develop hypotheses about the source of an outbreak.
2. **[Antibiotic resistance: exploring resistance genes and comparing phenotypes](amr/README.md).** Examine resistance genes in _Pseudomonas aeruginosa_, compare AMRFinderPlus results with laboratory susceptibility measurements, and run AMRFinderPlus on a _Staphylococcus epidermidis_ genome.
3. **[Plasmids and antimicrobial resistance in hospital metagenomes](metagenomics/README.md).** Explore the taxonomic composition of environmental samples, assemble plasmid-associated sequences, identify resistance genes, and search for related sequences in public databases.

Each project includes background, step-by-step instructions, and questions to guide interpretation. Use the workshop Jupyter environment for command-line and Jupyter notebook activities; the individual project READMEs describe the required tools and inputs.
