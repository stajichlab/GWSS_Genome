#!/usr/bin/bash
#SBATCH -p intel,batch
#SBATCH -o /logs/log.blob2.txt
#SBATCH -e /logs/log.blob2.txt
#SBATCH --nodes=1
#SBATCH --ntasks=16 # Number of cores
#SBATCH --mem=32G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -J gwss_blob2_create


module unload miniconda2
module load miniconda3

module load db-ncbi
module load db-uniprot

#activate blobtools 2 env
conda activate btk_env

export PATH=$PATH:/bigdata/software/blobtoolkit/blobtools2/

TAXFOLDER=taxonomy
DIR=data
COV=coverage
PREFIX=Homalodisca_vitripennis.A6A7A9_masurca_v1_ragtag

ASSEMBLY=${DIR}/$PREFIX.sorted.fasta
BAM=${COV}/$PREFIX.remap.bam
COVTAB=$BAM.cov
PROTTAX=${TAXFOLDER}/$PREFIX.diamond.tab.taxified.out
BLASTTAX=${TAXFOLDER}/$PREFIX.nt.blastn.tab.taxified.out


#create blob
blobtools create --fasta $ASSEMBLY --replace $PREFIX 

blobtools add --cov $BAM --threads 16 --replace $PREFIX

blobtools add --hits $PROTTAX --hits $BLASTTAX --taxrule bestsumorder --taxdump /bigdata/software/blobtoolkit/taxdump/ --replace $PREFIX

