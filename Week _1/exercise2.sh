#!/usr/bin/env bash

# First let’s create a directory to store the results from BWA-MEM:
mkdir Mapping

# Indexing the reference genome (MN908947.fasta) to optimize alignment speed and efficiency using BWA.
bwa index MN908947.fasta

# Now, we’re ready to map the sequences from our target sample to the reference genome
bwa mem MN908947.fasta ERR5743893_1.fastq ERR5743893_2.fastq > Mapping/ERR5743893.sam

# Once BWA MEM has finished running, change to the Mapping directory and list the files
cd Mapping
ls -lhrt

# Converting the large SAM file to a compressed BAM file using 
# samtools to save space and speed up downstream analysis.
samtools view -@ 20 -S -b Mapping/ERR5743893.sam > Mapping/ERR5743893.bam

# Sorting the BAM file by genomic coordinates using samtools to organize reads based on 
# their mapped positions in the reference genome.
samtools sort -@ 32 -o Mapping/ERR5743893.sorted.bam Mapping/ERR5743893.bam

# Index the sorted BAM file to enable fast access to specific genomic regions, 
# improving efficiency for variant calling, visualization, and downstream analysis.
samtools index Mapping/ERR5743893.sorted.bam