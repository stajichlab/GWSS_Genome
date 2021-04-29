#!/usr/bin/bash
#SBATCH -p stajichlab
#SBATCH -o logs/vecscreen.log.txt
#SBATCH -e logs/vecscreen.log.txt
#SBATCH --nodes=1
#SBATCH --ntasks=16 # Number of cores
#SBATCH --mem=24G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -J gwss_vec


IN_GEN="ragtag.scaffolds.fasta"
OUT_GEN="gwss.A6A7A9_masurca.ragtag.scaffolds.vecscreen.fasta"

module load AAFTF

AAFTF vecscreen -i $IN_GEN -o $OUT_GEN -c 16


