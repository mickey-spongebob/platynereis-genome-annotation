#!/bin/bash

## Convert bed6 repeat element format gff3

### add source column 2
awk 'BEGIN{FS=OFS="\t"}{$1 = $1 OFS "PdumGENOME_v0.5"}1' platy.falcon.fa.out.bed > \
RE-pdumgenomev05.gff3

### add feature column 3
awk 'BEGIN{FS=OFS="\t"}{$2 = $2 OFS "repeat_region"}1' RE-pdumgenomev05.gff3 > \
tmp && mv tmp RE-pdumgenomev05.gff3

### add float point at the last column
awk 'BEGIN{FS=OFS="\t"}{print $0 OFS "."}' RE-pdumgenomev05.gff3 > \
tmp && mv tmp RE-pdumgenomev05.gff3

### add numbers to last column as future IDs
awk -F'\t' 'NR{ $0=$0"\t"NR }1' RE-pdumgenomev05.gff3 > tmp && mv tmp RE-pdumgenomev05.gff3

### delete column 6 (contains the ';' delimited details from the 'platy.falcon.fa.out' file
awk 'BEGIN{FS=OFS="\t"}{$6=""; print}' RE-pdumgenomev05.gff3 > \
tmp && mv tmp RE-pdumgenomev05.gff3

sed -i 's/\t\t/\t/g' RE-pdumgenomev05.gff3

### edit last column
sed '1,3d' platy.falcon.fa.out | awk '{ print $10, $11 }' >  RE_list # extract names
sed -i 's/ /\t/g' RE_list # add tab-delim to file to allow for joining with the updated gff3 file

#paste
paste RE-pdumgenomev05.gff3 RE_list > tmp && mv tmp RE-pdumgenomev05.gff3

#add gene attributes
awk -F'\t' -vOFS='\t' '{ $(NF+1)="ID=RE"$9"; gene_id=RE"$9"; transcript_id=RE"$9"; family_id="$10"; class_id="$11 ; print }' \
RE-pdumgenomev05.gff3 > tmp && mv tmp RE-pdumgenomev05.gff3

#delete columns 9-11
cut -f1,2,3,4,5,6,7,8,12 RE-pdumgenomev05.gff3 > tmp && mv tmp RE-pdumgenomev05.gff3

#make identical file for exons
cp RE-pdumgenomev05.gff3 RE-exons-pdumgenomev05.gff3
sed -i 's/ID/Parent/g' RE-exons-pdumgenomev05.gff3
sed -i 's/repeat_region/exon/g' RE-exons-pdumgenomev05.gff3

##concatenate the 'exon' and 'repeat_region' files
cat RE-pdumgenomev05.gff3 RE-exons-pdumgenomev05.gff3 > RE-all-pdumgenomev05.gff3

