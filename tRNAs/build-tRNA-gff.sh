#!/bin/bash

# Construct a gff3 file from the tRNA output

## Remove the first three lines of file
sed '1,3d' tRNA_Pdum.out > tmp; mv tmp tRNA_coords.txt

## add a column to the second field 'PdumGENOME_v0.5'
awk 'BEGIN{ FS=OFS="\t" }{ $1 = $1 OFS "PdumGENOME_v0.5" }1' tRNA_coords.txt > \
tmp && mv tmp tRNA_coords.txt

## add a column to the third field 'tRNA'
awk 'BEGIN{ FS=OFS="\t" }{ $2 = $2 OFS "tRNA" }1' tRNA_coords.txt > \
tmp && mv tmp tRNA_coords.txt

## remove space character after first column
sed -i 's/ //g' tRNA_coords.txt

## add numbers to tRNA_coords.txt file for future gene IDs
awk -F'\t' 'NR{ $0=$0"\t"NR }1' tRNA_coords.txt > tmp && mv tmp tRNA_coords.txt

## edit the last column to hold gene attributes
awk -F'\t' -vOFS='\t' '{ $(NF+1)="ID="$13"; gene_id="$13"; transcript_id="$13"; gene_type="$7"_tRNA" ; print }' tRNA_coords.txt > \
tmp && mv tmp tRNA_coords.txt

## replace gene_type value in column 12 = pseudo
awk -F'\t' -vOFS='\t' '{ if ($12 == "pseudo") { $14="ID="$13"; gene_id="$13"; transcript_id="$13"; gene_type=Pseudo_tRNA" } print }' \
tRNA_coords.txt > tmp && mv tmp tRNA_coords.txt

## remove non-gff columns 4,7-13 (i.e. tRNA number in contig and Infinity Model scores)
cut -f1,2,3,5,6,14 tRNA_coords.txt > tmp && mv tmp tRNA_coords.txt

## Add the score, strandedness and phase
awk 'BEGIN{FS=OFS="\t"}{$5 = $5 OFS "."}1' tRNA_coords.txt > tmp && mv tmp tRNA_coords.txt

awk 'BEGIN{FS=OFS="\t"}{$6 = $6 OFS "+"}1' tRNA_coords.txt > tmp && mv tmp tRNA_coords.txt

awk 'BEGIN{FS=OFS="\t"}{$7 = $7 OFS "."}1' tRNA_coords.txt > tmp && mv tmp tRNA_coords.txt
