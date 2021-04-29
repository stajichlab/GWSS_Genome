#!/bin/bash -l
#SBATCH --ntasks=24 # Number of cores
#SBATCH --mem=200G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -p intel,batch
#SBATCH -o /logs/gwss.gtbdk.log
#SBATCH -e /logs/gwss.gtbdk.log
#SBATCH -J gtdbtk_gwss


module unload miniconda2
module load miniconda3

conda activate gtdbtk-1.3.0

INPUT=/Homalodisca_vitripennis.A6A7A9_masurca_v1_ragtag_v1.profile/SUMMARY_taxa/bin_fastas
OUTPUT=${INPUT}/gtbdk_results
CPU=24
PREFIX=Homalodisca_vitripennis.A6A7A9_masurca_v1_ragtag_v1_endosymbionts

gtdbtk classify_wf --genome_dir $INPUT --out_dir $OUTPUT -x .fa --cpus $CPU --prefix $PREFIX.gtbdk
