#!/bin/bash
##
#SBATCH -o /logs/quast_ragtag.log.txt
#SBATCH -e /logs/quast_ragtag.log.txt
#SBATCH --nodes=1
#SBATCH --ntasks=12 # Number of cores
#SBATCH --mem=60G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --time=24:00:00
#SBATCH -J gwss_ragtag_quast

module load busco
/bigdata/software/quast-5.0.2/quast.py data/Homalodisca_vitripennis.scaffolds.filtered.fasta data/GCA_000696855.2_Hvit_2.0_genomic.fna --threads 12 --eukaryote --large --space-efficient --conserved-genes-finding

