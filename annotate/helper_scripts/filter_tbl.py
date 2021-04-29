#python script to remove scaffolds from tbl files
#by cassie ettinger

import os, sys

def filter_tbl(input_tbl, output_tbl, scaffolds_remove):


	with open(scaffolds_remove) as f:
		contamination_ids = f.read().splitlines()


	
	contamination_ids_list = []
	for item in contamination_ids:
		contamination_ids_list.append(">Feature " + item + "\n")

	#print(contamination_ids_list)

	OutputFile = open(output_tbl, 'w') #opens new file to write to
	
	with open(input_tbl, "r") as fp:
		i = 0
		for line in fp:
			if line[0] != ">" and i == 0:
				OutputFile.write(line) #writes to file 
			elif line[0] == ">":
				if line in contamination_ids_list:
					i = 1 
				else: 
					OutputFile.write(line)
					i = 0					

filter_tbl("Homalodisca_vitripennis.tbl", "Homalodisca_vitripennis.filtered.tbl", "combined_scaffolds_to_remove.txt")

