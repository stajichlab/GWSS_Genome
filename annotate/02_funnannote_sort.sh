#!/usr/bin/bash
#SBATCH -p stajichlab
#SBATCH -o logs/fun.sort.log.txt
#SBATCH -e logs/fun.sort.log.txt
#SBATCH --nodes=1
#SBATCH --ntasks=16 # Number of cores
#SBATCH --mem=24G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -J gwss_fun_sort



module load funannotate/1.8
source activate funannotate-1.8

funannotate sort -i gwss.A6A7A9_masurca.ragtag.scaffolds.vecscreen.fasta -o gwss.A6A7A9_masurca.ragtag.scaffolds.vecscreen.sorted.fasta

