#!/bin/bash

# Build a .gff3 file for the miRNA mapping events annotated by miRDeep2

## merge genes that overlap with each other
sort -k1,1 -k2,2n result_10_03_2020_t_16_14_01.bed > miRNA_sorted.bed

bedtools merge -i miRNA_sorted.bed -s -c 4,6 -o collapse,collapse > \
merge-miRNA

sed -i 's/\+,//g' merge-miRNA #remove plus character including and after comma
sed -i 's/\-,//g' merge-miRNA #remove minus char. and the comma
sed -E 's/,novel:[A-z0-9]+//g' merge-miRNA > tmp && mv tmp merge-miRNA

## add columns so as to build gfff
awk 'BEGIN{FS=OFS="\t"}{$1 = $1 OFS "miRNA"}1' merge-miRNA > \
tmp && mv tmp merge-miRNA

## Add the source (column 2), score and frame (columns 6 and 8) 
awk 'BEGIN{FS=OFS="\t"}{$1 = $1 OFS "PdumGENOME_v0.5"}1' merge-miRNA > \
tmp && mv tmp merge-miRNA

awk 'BEGIN{FS=OFS="\t"}{$6 = ".\t" $6}1' merge-miRNA > \
tmp && mv tmp merge-miRNA

awk 'BEGIN{FS=OFS="\t"}{print $0 OFS "."}' merge-miRNA > \
tmp && mv tmp merge-miRNA

## edit last column to hold gene attributes
awk -F'\t' -vOFS='\t' '{ $(NF+1)="ID="$7"; gene_id="$7"; transcript_id="$7"; gene_type=miRNA" ; print }' merge-miRNA > \
tmp && mv tmp merge-miRNA

sed -i 's/novel://g' merge-miRNA #remove the 'novel:' text from the IDs
cut -f1,2,3,4,5,6,8,9,10 merge-miRNA > tmp && mv tmp merge-miRNA #remove 'novel:' column

#exons of miRNA
cp merge-miRNA exons-miRNA
sed -i 's/\tmiRNA/\texon/g' exons-miRNA
sed -i 's/ID/Parent/g' exons-miRNA

#merge exons and miRNA into single .gff3 file
cat merge-miRNA exons-miRNA > miRNA-pdumgenomev05.gff3
