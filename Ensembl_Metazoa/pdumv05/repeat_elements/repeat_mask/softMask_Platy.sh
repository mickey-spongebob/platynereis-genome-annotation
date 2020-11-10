#!/bin/bash

#SBATCH --mail-type=ALL
#SBATCH --mail-user=kevin.mutemi@embl.de
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --mem=48G
#SBATCH --time=24:00:00

# Load Perl
module load Perl

# Mask platy.falcon.fa
/scratch/mutemi/RepeatELE_Platy/RepeatMasker/RepeatMasker \
-e rmblast -pa 8 -s \
-lib /scratch/mutemi/RepeatELE_Platy/results/RepeatModeler_Platy/RM_56950.WedJul101744202019/consensi.fa.classified \
-a -xsmall platy.falcon.fa
