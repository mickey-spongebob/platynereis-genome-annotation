#!/bin/python 3

# Constructing a draft gff3 file
##conda env is 'platy_genome'

## Read in the partial and separate gff3 details into Python
### import necessary modules
import pandas as pd
import csv

### store the file paths as variables
genes_tsv_file = open("genes-gtf-merge.txt")
mRNA_tsv_file = open("transcripts-gtf-merge.txt")
exons_tsv_file = open("exons-gtf-merge.txt")

### read the files
genes_tsv = pd.read_csv(genes_tsv_file, delimiter = "\t", header = None)
mRNA_tsv = pd.read_csv(mRNA_tsv_file, delimiter = "\t", header = None)
exons_tsv = pd.read_csv(exons_tsv_file, delimiter = "\t", header = None)

### convert the data types of four columns
tsv_list = [genes_tsv, mRNA_tsv, exons_tsv]

for file in tsv_list:
    file[[0, 6, 8]] = file[[0, 6, 8]].astype(str)    # convert columns 0, 6 and 8 into string datatypes
    file[[3, 4]] = file[[3, 4]].astype(int)          # conver columns 3 and 4 into integers
    file

### View the files
#genes_tsv
#mRNA_tsv
#exons_tsv

# Attach gene attribute IDs to the Parent details in the mRNA tsv file,
for i in range(mRNA_tsv.shape[0]):
    
    ## if the contig details [column 0] and the strandedness info [column 6] are equivalent between
    ## the mRNA and genes *tsv files
        if (mRNA_tsv.iloc[i, 0] == genes_tsv.iloc[i, 0]) and (mRNA_tsv.iloc[i, 6] == genes_tsv.iloc[i, 6]) is True:
            
            ## if mRNA 'end' position [column 4] is between genes 'start' position [column 3] and genes 'end' position [column 4]
            if (mRNA_tsv.iloc[i, 4] >= genes_tsv.iloc[i, 3] <= genes_tsv.iloc[i, 4]):
                
                ## if mRNA 'start' position [column 3] is between genes 'start' position [column 3] and genes 'end' position [column 4]
                if (mRNA_tsv.iloc[i, 3] >= genes_tsv.iloc[i, 3] <= genes_tsv.iloc[i, 4]):
                    
                    ## Edit the column 8 'attributes' by adding 'Parent =' gene attribute details except the 'ID='
                    mRNA_tsv.iloc[i, 8] = 'Parent=' + genes_tsv.at[i, 8][3:]
        else:
            print ('Row values are not compatible for merging')
mRNA_tsv

# Write to new file mRNA_IDs_gff
mRNA_tsv.to_csv('mRNA_IDs_gff', sep = '\t', index=False, header=False)


# Attach gene attribute IDs to the Parent details in the exon tsv file
for i in range(exons_tsv.shape[0]):
    for z in range(genes_tsv.shape[0]):
        if (exons_tsv.iloc[i, 0] == genes_tsv.iloc[z, 0]) and (exons_tsv.iloc[i, 6] == genes_tsv.iloc[z, 6]) is True:
            
            ## if mRNA 'end' position [column 4] is between genes 'start' position [column 3] and genes 'end' position [column 4]
            if (exons_tsv.iloc[i, 4] >= genes_tsv.iloc[z, 3] <= genes_tsv.iloc[z, 4]):
                
                ## if mRNA 'start' position [column 3] is between genes 'start' position [column 3] and genes 'end' position [column 4]
                if (exons_tsv.iloc[i, 3] >= genes_tsv.iloc[z, 3] <= genes_tsv.iloc[z, 4]):
                    
                    ## Edit the column 8 'attributes' by adding 'Parent =' gene attribute details except the 'ID='
                    exons_tsv.iloc[i, 8] = 'Parent=' + genes_tsv.at[z, 8][3:]
        else:
            pass
exons_tsv

# Write to new file exons_IDs_gff
exons_tsv.to_csv('exons_IDs_gff', sep = '\t', index=False, header=False)