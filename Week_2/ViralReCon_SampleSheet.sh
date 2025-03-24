#!/usr/bin/env bash

# create a text file called sample.txt that will store all the accession.
# (ERR5556343 SRR13500958 ERR5743893 ERR5181310 ERR5405022)

# use a for loop to run fastq-dump on each of the accessions in samples.txt
for i in $(cat sample.txt);do fastq-dump --split-files $i;done

# compressed all downloaded fastq files
gzip *.fastq

# Now create a directory called data and move the fastq files there
mkdir data
mv *.fastq.gz data

# Creating the samplesheet.csv file
# we use a python script to create this file, the link to download the file is below.
wget -L https://raw.githubusercontent.com/nf-core/viralrecon/master/bin/fastq_dir_to_samplesheet.py

# we run the python script to create the samplesheet.csv
python3 fastq_dir_to_samplesheet.py data samplesheet.csv -r1 _1.fastq.gz -r2 _2.fastq.gz

# we can now see what is in the samplesheet.csv
cat samplesheet.csv