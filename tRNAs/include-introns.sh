#!/bin/bash

# include intron information into tRNA-gff3 file

## Remove the first three lines of tRNA_Pdum.out file
sed '1,3d' tRNA_Pdum.out > tmp; mv tmp tRNA_introns

## Remove columns 2,3,4,6,9
cut -f1,5,7,8,10 tRNA_introns > tmp && mv tmp tRNA_introns

## add a column to the second field 'PdumGENOME_v0.5'
awk 'BEGIN{ FS=OFS="\t" }{ $1 = $1 OFS "PdumGENOME_v0.5" }1' tRNA_introns > \
tmp && mv tmp tRNA_introns

## add a column to the third field 'intron'
awk 'BEGIN{ FS=OFS="\t" }{ $2 = $2 OFS "intron" }1' tRNA_introns > \
tmp && mv tmp tRNA_introns

## remove white-space between contig and assembly type column
sed -i 's/ //g' tRNA_introns

## add numbers to tRNA_introns file
awk -F'\t' 'NR{ $0=$0"\t"NR }1' tRNA_introns > tmp && mv tmp tRNA_introns

## edit the last column to hold gene attributes
awk -F'\t' -vOFS='\t' '{ $(NF+1)="Parent="$8"; gene_id="$8"; transcript_id="$8"; gene_type="$4"_tRNA" ; print }' tRNA_introns > \
tmp && mv tmp tRNA_introns

## replace gene_type value in column 12 = pseudo
awk -F'\t' -vOFS='\t' '{ if ($7 == "pseudo") { $9="Parent="$8"; gene_id="$8"; transcript_id="$8"; gene_type=Pseudo_tRNA" } print }' \
tRNA_introns > tmp && mv tmp tRNA_introns

## Remove columns 4,7,8
cut -f1,2,3,5,6,9 tRNA_introns > tmp && mv tmp tRNA_introns

## Add the score, strandedness and phase
awk 'BEGIN{FS=OFS="\t"}{$5 = $5 OFS "."}1' tRNA_introns > tmp && mv tmp tRNA_introns

awk 'BEGIN{FS=OFS="\t"}{$6 = $6 OFS "+"}1' tRNA_introns > tmp && mv tmp tRNA_introns

awk 'BEGIN{FS=OFS="\t"}{$7 = $7 OFS "."}1' tRNA_introns > tmp && mv tmp tRNA_introns

## Remove rows where columns 4 and 5 are 0
awk -F'\t' -vOFS='\t' '$4!=0' tRNA_introns > tmp && mv tmp tRNA_introns
# could also add $5!=0


