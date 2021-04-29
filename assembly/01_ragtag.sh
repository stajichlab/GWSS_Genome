#!/bin/bash
##
#SBATCH -o /log/ragtag_log.txt
#SBATCH -e /log/ragtag_log.txt
#SBATCH --nodes=1
#SBATCH --ntasks=12 # Number of cores
#SBATCH --mem=60G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --time=12:00:00
#SBATCH -J gwss_ragtag


module load ragtag/1.0.0

ragtag.py scaffold data/GCA_000696855.2_Hvit_2.0_genomic.fna data/masurca.A6_A7_A9.flye.assembly.fasta -o ragtag_scaffold_contigs
