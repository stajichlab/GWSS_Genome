#python script to filter out scaffolds from gbk file
#by cassie ettinger

import os, sys

def filter_tbl(input_gbk, output_gbk, scaffolds_remove):


	with open(scaffolds_remove) as f:
		contamination_ids = f.read().splitlines()


	
	contamination_ids_list = []
	for item in contamination_ids:
		contamination_ids_list.append(item + "\n")

	#print(contamination_ids_list)

	OutputFile = open(output_gbk, 'w') #opens new file to write to
	
	with open(input_gbk, "r") as fp:
		i = 0
		for line in fp:
			if line[0:5] != "LOCUS" and i == 0:
				OutputFile.write(line) #writes to file 
			elif line[0:5] == "LOCUS":
				if line in contamination_ids_list:
					i = 1 
				else: 
					OutputFile.write(line)
					i = 0					



#for scaffold in $(cat submission/combined_scaffolds_to_remove.txt);
#do grep -w $scaffold Homalodisca_vitripennis_A6A7A9_masurca_v1_ragtag_v1.gbk >> submission/HV_lines_remove_gbk.txt;
#done

filter_tbl("../Homalodisca_vitripennis_A6A7A9_masurca_v1_ragtag_v1.gbk", "genome/Homalodisca_vitripennis_A6A7A9_masurca_v1_ragtag_v1.gbk", "HV_lines_remove_gbk.txt")
