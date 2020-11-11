#!/bin/bash

## Merge clusters of transcripts into a singular long gene model
## Predominantly useful for purely have gene loci

### Installed bedtools via conda into a conda cufllinks env.
#conda install -c bioconda bedtools

### Installed bedops via conda into a conda cufflinks env
#conda install -c bioconda bedops

## collect only the exons from the pdum_genome_alltXOME_v1.0.pasa_assemblies.gtf
grep "exon" pdum_genome_alltXOME_v1.0.pasa_assemblies.gtf > exons.gtf

## Convert exons.gtf file to .bed file
convert2bed -i gtf < exons.gtf > exons-gtf.bed

## bedtools merge on 'exon'
bedtools merge -i exons-gtf.bed -s -c 6 -o collapse \
> exons-gtf-merge
	### reduced exon count from 290,000 to 210,000
sed -i 's/,.*//' exons-gtf-merge #remove extra comma characters

#
## add columns to bed file so as to build a gtf
awk 'BEGIN{FS=OFS="\t"}{$1 = $1 OFS "exon"}1' exons-gtf-merge > \
tmp && mv tmp exons-gtf-merge

## Add the source (column 2), score and frame (columns 6 and 8) into both *-gtf-merge-bed files
awk 'BEGIN{FS=OFS="\t"}{$1 = $1 OFS "PdumGENOME_v0.5"}1' exons-gtf-merge > \
tmp && mv tmp exons-gtf-merge

awk 'BEGIN{FS=OFS="\t"}{$6 = ".\t" $6}1' exons-gtf-merge > \
tmp && mv tmp exons-gtf-merge

awk 'BEGIN{FS=OFS="\t"}{print $0 OFS "."}' exons-gtf-merge > \
tmp && mv tmp exons-gtf-merge

## collect only the transcripts from the pdum_genome_alltXOME_v1.0.pasa_assemblies.gtf
awk '$3 == "transcript" {print($0)}' pdum_genome_alltXOME_v1.0.pasa_assemblies.gtf \
> transcripts.gtf

## repeat conversion to bed and merging and conversion back to gtf
convert2bed -i gtf < transcripts.gtf > transcripts-gtf.bed

bedtools merge -i transcripts-gtf.bed -s -d 1000 -c 6 -o collapse \
> transcripts-gtf-merge

sed -i 's/,.*//' transcripts-gtf-merge #remove extra comma characters

#
## add columns to bed file so as to build a gtf
awk 'BEGIN{FS=OFS="\t"}{$1 = $1 OFS "mRNA"}1' transcripts-gtf-merge > \
tmp && mv tmp transcripts-gtf-merge

## Add the source (column 2), score and frame (columns 6 and 8) into both *-gtf-merge-bed files
awk 'BEGIN{FS=OFS="\t"}{$1 = $1 OFS "PdumGENOME_v0.5"}1' transcripts-gtf-merge > \
tmp && mv tmp transcripts-gtf-merge

awk 'BEGIN{FS=OFS="\t"}{$6 = ".\t" $6}1' transcripts-gtf-merge > \
tmp && mv tmp transcripts-gtf-merge

awk 'BEGIN{FS=OFS="\t"}{print $0 OFS "."}' transcripts-gtf-merge > \
tmp && mv tmp transcripts-gtf-merge

#
## Increase mRNA boundaries by 1000bp to create a 'genes' gtf file
awk 'BEGIN{FS=OFS="\t"}{print $1 OFS $2 OFS $3 OFS $4-1000 OFS $5+1000 OFS $6 OFS $7 OFS $8}' \
transcripts-gtf-merge > genes-gtf-merge

sed -i 's/mRNA/gene/g' genes-gtf-merge #replace mRNA feature to gene

## Incorporate these distinct three files into a .gff file
### Access the pasa_assemblies .bed file and sort it
sort -k1,1 -k2,2n pdum_genome_alltXOME_v1.0.pasa_assemblies.bed > \
pdum_genome_alltXOME_v1.0.pasa_assemblies.sorted.bed

### merge the sorted.bed file: equivalent file to the transcripts-gtf-merge initial file
bedtools merge -i pdum_genome_alltXOME_v1.0.pasa_assemblies.sorted.bed -s \
-c 4 -o collapse -d 1000 > transcript_locus-merge

### collect the ID information so as to add this column into the genes-gtf-merge file
awk '{ print $4 }' transcript_locus-merge > IDs.txt

paste -d"\t" genes-gtf-merge IDs.txt > genes-gtf-merge.txt

sed -i 's/-[0-9][0-9]*/1/' genes-gtf-merge.txt
