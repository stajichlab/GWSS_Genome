#python script to filter out contaminant scaffolds
#by cassie ettinger

import sys
import Bio
from Bio import SeqIO

def filter_fasta(input_fasta, output_fasta, contamination): 
	seq_records = SeqIO.parse(input_fasta, format='fasta') #parses the fasta file
	

	with open(contamination) as f:
		contamination_ids_list = f.read().splitlines() #parse the contamination file which is each line as a scaffold id 
	#print(contamination_ids_list)	

	OutputFile = open(output_fasta, 'w') #opens new file to write to
	
	for record in seq_records: 
		if record.id not in contamination_ids_list: 
			OutputFile.write('>'+ record.id +'\n') #writes the scaffold to the file (or assession) 
			OutputFile.write(str(record.seq)+'\n') #writes the seq to the file
			
	OutputFile.close()


filter_fasta("Homalodisca_vitripennis.scaffolds.fa", "Homalodisca_vitripennis.scaffolds.filtered.fasta", "combined_scaffolds_to_remove.txt")		
