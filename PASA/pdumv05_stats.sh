# Commands used to get statistics from the pdumv05 genome version

## conda activate python2
gt stat -genelengthdistri pdumgenomev05.gff3 > pdumv05-genelengthdist.txt
gt stat -exonlengthdistri pdumgenomev05.gff3 > pdumv05-exonlengthdist.txt

gt gff3_to_gtf pdumgenomev05.gff3 > pdumgenomev05.gtf

## conda activate platy_genome
convert2bed --input=gtf --output=gtf < test4.gtf | datamash -sg 4 count 8 | awk '$2==1' | wc -l
### 69,239 single-exon genes, possibly non-coding RNA loci and G-protein-coupled-receptors (GPCRs)

convert2bed --input=gtf --output=gtf < test4.gtf | datamash -sg 4 count 8 | awk '$2>1' | wc -l
### 26,800 multi-exonic genes 
