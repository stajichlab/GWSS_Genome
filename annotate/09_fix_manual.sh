#!/bin/bash
#SBATCH -p batch  
#SBATCH --ntasks 4 
#SBATCH --nodes 1 
#SBATCH --mem 24G 
#SBATCH --out logs/fix.postcontam.%a.log
#SBATCH -J gwss_fix_manual
#SBATCH --array 1
#SBATCH --time=1-0:00:00

module unload perl
module unload miniconda2
module unload miniconda3
module load anaconda3
module load funannotate/1.8
module unload perl
module unload python
conda activate funannotate-1.8

export AUGUSTUS_CONFIG_PATH=$(realpath lib/augustus/3.3/config)
# Set some vars

export FUNANNOTATE_DB=/bigdata/stajichlab/shared/lib/funannotate_db
export PASAHOMEPATH=$(dirname `which Launch_PASA_pipeline.pl`)
export PASAHOME=$(dirname  `which Launch_PASA_pipeline.pl`)
export TRINITY=$(realpath `which Trinity`)
export TRINITYHOMEPATH=$(dirname $TRINITY)
export PASACONF=$(realpath ~/pasa.config.txt)


INDIR=genomes
OUTDIR=annotate
SAMPFILE=genomes/samples.csv

#removing virus/bacterial reads and respective genes
#fixing vasa/white (hopefully)
#cp fixed file into annotate to replace old file, only need one of table or list of genes
#since we had to fix vasa/white, only providing table otherwise genes would be needed

funannotate fix -i annotate/Homalodisca_vitripennis.A6A7A9_masurca_v1_ragtag_v1/update_results/Homalodisca_vitripennis.gbk -t annotate/Homalodisca_vitripennis.A6A7A9_masurca_v1_ragtag_v1/update_results/Homalodisca_vitripennis.tbl
