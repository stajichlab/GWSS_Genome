#!/bin/bash
##
#SBATCH -o /rhome/cassande/bigdata/GWSS/GWSS_Genome/GWSS_scaffold/scaffold_vs_i5k/quast_ragtag.log.txt
#SBATCH -e /rhome/cassande/bigdata/GWSS/GWSS_Genome/GWSS_scaffold/scaffold_vs_i5k/quast_ragtag.log.txt
#SBATCH --nodes=1
#SBATCH --ntasks=12 # Number of cores
#SBATCH --mem=60G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --time=24:00:00
#SBATCH -D /rhome/cassande/bigdata/GWSS/GWSS_Genome/GWSS_scaffold/scaffold_vs_i5k/
#SBATCH -J gwss_ragtag_quast
#SBATCH --mail-type=END # notifications for job done & fail
#SBATCH --mail-user=cassande@ucr.edu # send-to address

module load busco
/rhome/cassande/bigdata/software/quast-5.0.2/quast.py data/Homalodisca_vitripennis.A6A7A9_masurca_v1.sorted.fasta ragtag_correct_scaffolds/Homalodisca_vitripennis.A6A7A9_masurca_v1.sorted.corrected.fasta data/masurca.A6_A7_A9.flye.assembly.fasta ragtag_scaffold_contigs/ragtag.scaffolds.fasta  --threads 12 --eukaryote --large --space-efficient --conserved-genes-finding -r data/GCA_000696855.2_Hvit_2.0_genomic.fna

