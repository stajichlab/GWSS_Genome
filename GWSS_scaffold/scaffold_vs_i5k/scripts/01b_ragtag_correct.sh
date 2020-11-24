#!/bin/bash
##
#SBATCH -o /rhome/cassande/bigdata/GWSS/GWSS_Genome/GWSS_scaffold/scaffold_vs_i5k/ragtag_cor_log.txt
#SBATCH -e /rhome/cassande/bigdata/GWSS/GWSS_Genome/GWSS_scaffold/scaffold_vs_i5k/ragtag_cor_log.txt
#SBATCH --nodes=1
#SBATCH --ntasks=12 # Number of cores
#SBATCH --mem=60G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --time=12:00:00
#SBATCH -D /rhome/cassande/bigdata/GWSS/GWSS_Genome/GWSS_scaffold/scaffold_vs_i5k/
#SBATCH -J gwss_ragtag_corr
#SBATCH --mail-type=END # notifications for job done & fail
#SBATCH --mail-user=cassande@ucr.edu # send-to address


module load ragtag/1.0.0

ragtag.py correct data/GCA_000696855.2_Hvit_2.0_genomic.fna data/Homalodisca_vitripennis.A6A7A9_masurca_v1.sorted.fasta -o ragtag_correct_scaffolds
