#!/usr/bin/env Rscript

library(optparse)

# Define command-line options
option_list <- list(
  make_option(c("--drug"), type = "character", default = NULL,
              help = "Antibiotic name (e.g., 'Ciprofloxacin')", metavar = "CHARACTER"),
  make_option(c("--taxgroup"), type = "character", default = NULL,
              help = "Taxonomic group (e.g., 'Escherichia coli')", metavar = "CHARACTER"),
  make_option(c("--drug_class_list"), type = "character", default = NULL,
              help = "Comma-separated list of drug classes (e.g., 'Quinolones,Fluoroquinolones')", metavar = "CHARACTER"),
  make_option(c("--standard"), type = "character", default = "clsi",
              help = "SIR interpretation standard ('clsi' or 'eucast') [default= clsi]", metavar = "CHARACTER"),
  make_option(c("--phenotypes"), type = "character", default = "asts.tsv",
              help = "Path to AST phenotype TSV file [default= asts.tsv]", metavar = "CHARACTER"),
  make_option(c("--genotypes"), type = "character", default = "microbigge.tsv",
              help = "Path to MicroBIGG-E genotype TSV file [default= microbigge.tsv]", metavar = "CHARACTER")
)

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

# Validate required options
if (is.null(opt$drug) || is.null(opt$taxgroup) || is.null(opt$drug_class_list)) {
  print_help(opt_parser)
  stop("Error: --drug, --taxgroup, and --drug_class_list are all required.", call. = FALSE)
}

opt$standard <- tolower(opt$standard)
if (!(opt$standard %in% c("clsi", "eucast"))) {
  stop("Error: --standard must be either 'clsi' or 'eucast'.", call. = FALSE)
}

# Check if input files exist
if (!file.exists(opt$phenotypes)) {
  stop(paste("Error: File not found:", opt$phenotypes), call. = FALSE)
}
if (!file.exists(opt$genotypes)) {
  stop(paste("Error: File not found:", opt$genotypes), call. = FALSE)
}

# Load other libraries
library(dplyr)
library(AMRgen)
library(ggplot2)

cat(paste("Reading genotypes from", opt$genotypes, "...\n"))
raw_geno <- read.table(opt$genotypes, sep="\t", header=TRUE, as.is=TRUE, quote="", comment="", check.names=FALSE)
# fix the field names because the first line starts with a '#' character
names(raw_geno)[1] <- sub("^#", "", names(raw_geno)[1])

cat(paste("Reading phenotypes from", opt$phenotypes, "...\n"))
raw_ast <- read.table(opt$phenotypes, sep="\t", header=TRUE, as.is=TRUE, quote="", comment="", check.names=FALSE)
# fix the field names because the first line starts with a '#' character
names(raw_ast)[1] <- sub("^#", "", names(raw_ast)[1])

# Parse drug classes list
raw_classes <- trimws(strsplit(opt$drug_class_list, ",")[[1]])

cat("Filtering datasets by taxgroup, drug, and drug classes...\n")
# Filter genotypes by taxgroup
filtered_geno <- raw_geno %>%
  filter(grepl(opt$taxgroup, `Scientific name`, ignore.case = TRUE))

# Filter phenotypes by taxgroup and drug
filtered_ast <- raw_ast %>%
  filter(grepl(opt$taxgroup, `Scientific name`, ignore.case = TRUE)) %>%
  filter(AMR::as.ab(Antibiotic) == AMR::as.ab(opt$drug))

# Check if data was retrieved
if (nrow(filtered_geno) == 0) {
  stop("No genotypes found for the specified taxonomic group and drug classes in the file.", call. = FALSE)
}
if (nrow(filtered_ast) == 0) {
  stop("No phenotypes found for the specified taxonomic group and drug in the file.", call. = FALSE)
}

cat("Processing and cleaning genotypes...\n")
# Map/rename columns in filtered_geno to look like AMRFinderPlus output for import_amrfp
amrfinder <- filtered_geno %>%
  dplyr::rename(
    "Gene symbol" = `Element symbol`,
    "Element type" = `Type`,
    "Hierarchy node" = `Hierarchy node ID`,
    "Element subtype" = `Subtype`
  )
geno <- import_amrfp(amrfinder, sample_col = "BioSample")

cat("Processing and cleaning phenotypes...\n")
# Clean up MIC (mg/L) and Measurement sign columns to prevent invalid combinations
# (like ">=NA") from causing warnings that trigger a crash in cli's warning formatter
invalid_mic <- is.na(filtered_ast[["MIC (mg/L)"]]) | filtered_ast[["MIC (mg/L)"]] == 2.5
filtered_ast[["MIC (mg/L)"]][invalid_mic] <- ""
filtered_ast[["Measurement sign"]][invalid_mic] <- ""
filtered_ast[["Measurement sign"]][is.na(filtered_ast[["Measurement sign"]])] <- ""

# Rename Laboratory typing method column if needed
filtered_ast <- filtered_ast %>%
  dplyr::rename("Laboratory typing method" = "Laboratory typing method version or reagent")

# Set up standard-specific interpretation parameters
interpret_clsi <- FALSE
interpret_eucast <- FALSE
sir_col <- NULL

if (opt$standard == "clsi") {
  interpret_clsi <- TRUE
  sir_col <- "pheno_clsi"
} else {
  interpret_eucast <- TRUE
  sir_col <- "pheno_eucast"
}

pheno <- import_ncbi_pheno(
  filtered_ast,
  species = opt$taxgroup,
  interpret_clsi = interpret_clsi,
  interpret_eucast = interpret_eucast
)

cat("Generating UpSet plot...\n")
upset_result <- amr_upset(
  geno_table = geno,
  pheno_table = pheno,
  pheno_drug = opt$drug,
  geno_class = raw_classes,
  sir_col = sir_col,
  assay = "mic",
  print_category_counts = TRUE
)

