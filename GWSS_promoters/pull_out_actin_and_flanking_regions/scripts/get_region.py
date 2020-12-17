import os, sys

def get_region(file_name, start, stop, buffer):
### takes in scaffold and returns sequence plus region on either side of sequence of interest
### file_name = fasta file with a single scaffold of interest
### start = start position in scaffold for gene
### stop = stop position in scaffold for gene
### buffer = how many bp on each side of gene requested


	region_seq=""
	i = 1
	region_start = start - buffer
	region_stop = stop + buffer

	with open(file_name, "r") as fp:
		next(fp)
		for line in fp:
			print(line)
			
			for bp in line: 
				if i >= region_start:
					region_seq += bp
					i += 1
				elif i > region_stop:
					return(region_seq)					
