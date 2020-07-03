#!/bin/bash

## concatenate genes,mRNA and exon gff files
cat genes-gtf-merge.txt mRNA_IDs_gff exons_IDs_gff > pdumgenome05.gff3

## remove extra IDs info
sed -i 's/,.*//g' pdumgenome05.gff3

## conda env python2 to use the genometools bioinformatic tool
gt gff3validator pdumgenome05.gff3
# returned that sequence regions need to be added 

gt gff3 -tidy pdumgenome05.gff3 > tmp && mv tmp pdumgenome05.gff3

## add introns
gt gff3 -retainids -addintrons pdumgenomev05.gff3 > tmp && mv tmp pdumgenomev05.gff3

## add PdumGENOME_v05 to the intron rows
### conda env platy_genome
awk -F'\t' -vOFS='\t' '{ if ($2 == ".") {$2="PdumGENOME_v0.5"} print }' pdumgenomev05.gff3 \
> tmp && mv tmp pdumgenomev05.gff3

