#!/usr/bin/env bash

# First, let’s create a directory to save our fastQC outputs to:
mkdir -p QC_Reports

# Quality check using FastQC
fastqc ERR5743893_1.fastq ERR5743893_2.fastq --outdir QC_Reports

# Use MultiQC to aggregate and summarize FastQC reports
cd QC_Reports
multiqc .