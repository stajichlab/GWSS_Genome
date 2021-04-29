#!/bin/bash
##
#SBATCH -o /rhome/cassande/bigdata/GWSS/GWSS_Genome/GWSS_scaffold/scaffold_vs_i5k/busco.up.log.txt
#SBATCH -e /rhome/cassande/bigdata/GWSS/GWSS_Genome/GWSS_scaffold/scaffold_vs_i5k/busco.up.log.txt
#SBATCH --nodes=1
#SBATCH -D /rhome/cassande/bigdata/GWSS/GWSS_Genome/GWSS_scaffold/scaffold_vs_i5k/
#SBATCH -J gwss_busco_nocontam
#SBATCH --mail-type=END # notifications for job done & fail
#SBATCH --mail-user=cassande@ucr.edu # send-to address
#SBATCH -p stajichlab
#SBATCH --ntasks=24 # Number of threads
#SBATCH --mem=32G # Memory pool for all cores (see also --mem-per-cpu)


module unload miniconda2
module load augustus/3.3.3
module load hmmer 
module load ncbi-blast/2.2.31+ 
module load R

module load miniconda3

source activate busco5

export BUSCO_CONFIG_FILE=$(realpath config.ini)
export AUGUSTUS_CONFIG_PATH="/bigdata/software/augustus_3.3.3/config/"

BUSCO_PATH=$(realpath config.ini)

busco -i data/GCA_000696855.2_Hvit_2.0_genomic.fna -l hemiptera_odb10 -o busco_hem_i5k -m genome --config $BUSCO_PATH --cpu 24 -f

busco -i data/Homalodisca_vitripennis.scaffolds.filtered.fasta -l hemiptera_odb10 -o busco_hem_nocontam -m genome --config $BUSCO_PATH --cpu 24 -f 


