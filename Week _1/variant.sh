#!/usr/bin/env bash

# Index the reference genome to enable efficient access for variant calling
samtools faidx MN908947.fasta

# Perform variant calling on the mapped sample using FreeBayes and output results in VCF format  
freebayes -f MN908947.fasta Mapping/ERR5743893.sorted.bam > ERR5743893.vcf

# Compress and index the VCF file to save space and enable efficient querying  
bgzip ERR5743893.vcf  
tabix ERR5743893.vcf.gz

# Extract the header of the VCF file
zgrep "^##" ERR5743893.vcf.gz

# Extracting Variant Information
zgrep -v '^#' ERR5743893.vcf.gz | cut -f 8 | grep -oE 'TYPE=[^;]+' | sort | uniq -c