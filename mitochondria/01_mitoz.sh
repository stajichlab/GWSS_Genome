#!/usr/bin/bash
#SBATCH -p intel,batch
#SBATCH -o /logs/log.01.txt
#SBATCH -e /logs/log.01.txt
#SBATCH --nodes=1
#SBATCH --ntasks=24 # Number of cores
#SBATCH --mem=248G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -J gwss_mitoz_all

module load db-ncbi/20190805  
module load mitoz
source activate mitozEnv

DIR=data
FREADS=${DIR}/FB_A6_S35_L001_R1_001.fastq.gz
REVREADS=${DIR}/FB_A6_S35_L001_R2_001.fastq.gz
ASSEMBLY=${DIR}/Homalodisca_vitripennis.A6A7A9_masurca_v1_ragtag.sorted.fasta
CPU=24

export PATH=$PATH:$(realpath ncbiquery.py)


MitoZ.py all \
 --clade Arthropoda \
 --thread_number 24 \
 --fastq1 $FREADS \
 --fastq2 $REVREADS \
 --fastq_read_length 150 \
 --outprefix gwss_mito \
 --run_mode 2 \
 --filter_taxa_method 1 \
 --requiring_taxa 'Arthropoda'
