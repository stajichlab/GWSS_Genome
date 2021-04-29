#!/usr/bin/bash
#SBATCH -p stajichlab
#SBATCH -N 1 
#SBATCH -n 64 
#SBATCH --mem 96gb 
#SBATCH --out logs/rmasker_repbase.log
#SBATCH -J gwss_rmasker_rebase

module load RepeatMasker/4-1-1
module load funannotate
module unload ncbi-rmblast
module load ncbi-rmblast/2.9.0-p2
module unload miniconda2
module load miniconda3
module load mcclintock
source activate mcclintock

RepeatMasker -pa 64 -s -e ncbi -species Hemiptera genomes/gwss.A6A7A9_masurca.ragtag.scaffolds.vecscreen.sorted.fasta > H_vitripennis.A6A7A9.ragtag.RM.out
