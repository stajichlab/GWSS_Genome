#!/bin/bash
##
#SBATCH -o /logs/busco.log.euk.txt
#SBATCH -e /logs/busco.log.euk.txt
#SBATCH --nodes=1
#SBATCH --ntasks=12 # Number of cores
#SBATCH --mem=60G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --time=48:00:00
#SBATCH -J gwss_busco_euk

module unload miniconda2
module load augustus/3.3.3
module load hmmer 
module load ncbi-blast/2.2.31+ 
module load R

module load miniconda3

source activate busco5

conda info --envs

export BUSCO_CONFIG_FILE=$(realpath config.ini)
export AUGUSTUS_CONFIG_PATH="/bigdata/software/augustus_3.3.3/config/"

BUSCO_PATH=$(realpath config.ini)


busco -i data/GCA_000696855.2_Hvit_2.0_genomic.fna -l eukaryota_odb10 -o busco_euk_i5k_v5 -m genome --config $BUSCO_PATH --cpu 12 

busco -i data/Homalodisca_vitripennis.scaffolds.filtered.fasta -l eukaryota_odb10 -o busco_euk_ragatag_vecscreen_nocontam -m genome --config $BUSCO_PATH --cpu 12 



