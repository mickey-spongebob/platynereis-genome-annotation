#!/bin/bash

## Predicting tRNA sequences from Falcon assembly of the Platynereis genome

### tRNAscan-SE 2.0.3 using default settings
tRNAscan-SE -d -o /Users/mutemi/Data/Pdum_GENOME_TRANSCRIPTOME/tRNA_Pdum.out \
-f /Users/mutemi/Data/Pdum_GENOME_TRANSCRIPTOME/tRNAmodels_Pdum.ss \
-m /Users/mutemi/Data/Pdum_GENOME_TRANSCRIPTOME/tRNAcan-SE_Pdum.stats \
/Users/mutemi/Data/Pdum_GENOME_TRANSCRIPTOME/platy.falcon.fa

