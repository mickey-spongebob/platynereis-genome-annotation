## Install AGAT @Downloaded the AGAT: Another Gff Analysis Toolkit
### https://github.com/NBISweden/AGAT/blob/master/README.md

## conda activate platy_genome
## conda install -c bioconda agat

### Extract features from the ~1 million tXOME
agat_sp_statistics.pl --gff GMAP_Platy_tXOME.gff -o P.dumerilii_tXOME_features.txt
