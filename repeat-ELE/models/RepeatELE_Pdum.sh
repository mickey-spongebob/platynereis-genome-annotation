#!/bin/bash

#SBATCH --mail-type=ALL
#SBATCH --mail-user=kevin.mutemi@embl.de
#SBATCH -N 1
#SBATCH --mem=64G
#SBATCH -C "epyc"
#SBATCH -n 8
#SBATCH --time=05-00:00:00

# Build RepeatModeler database of platy.falcon.fa using the RMBlast engine
/scratch/mutemi/RepeatELE_Platy/RepeatModeler-open-1.0.11/BuildDatabase -name Platy_Dbase \
platy.falcon.fa 

# Execute RepeatModeler using the RMBlast engine
/scratch/mutemi/RepeatELE_Platy/RepeatModeler-open-1.0.11/RepeatModeler \
-pa 3 -database Platy_Dbase > run.out  
