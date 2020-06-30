#!/Users/mutemi/opt/anaconda3/envs/platy_genome/bin/python

# Correct the strandedness of the tRNA sequences

## Read in partial gff file into a Python variable
### import modules
import pandas as pd

### store the file paths as variables
tRNA_tsv_file = open("tRNA_coords.txt")

### read the files
tRNA_tsv = pd.read_csv(tRNA_tsv_file, delimiter = "\t", header = None)

### convert the data types of four columns
tRNA_tsv[[0, 6, 8]] = tRNA_tsv[[0, 6, 8]].astype(str)    # convert columns 0, 6 and 8 into string datatypes
tRNA_tsv[[3, 4]] = tRNA_tsv[[3, 4]].astype(int)      # convert columns 3 and 4 into integers

### view file
#tRNA_tsv

### Correct strandedness info (i.e. '+' into '-' if the 'start' column value[3] is greater than the 'end' column[4]
for i in range(tRNA_tsv.shape[0]):
	if (tRNA_tsv.iloc[i, 3] > tRNA_tsv.iloc[i, 4]):
		tRNA_tsv.iloc[i, 6] = '-'
	else:
	    pass
tRNA_tsv

### Swap the values of columns 3 and 4 where the strandedness (column 6) indicates '-'
minus = tRNA_tsv[6] == "-"

tRNA_tsv.loc[minus, [3, 4]] = (tRNA_tsv.loc[minus, [4, 3]].values)
tRNA_tsv

### Write dataframe to tsv file
tRNA_tsv.to_csv('tRNA-gff3', sep = "\t", index = False, header = False)
