#!/usr/bin/bash
#SBATCH -p short
#SBATCH -o /logs/filt.log.txt
#SBATCH -e /logs/filt.log.txt
#SBATCH --nodes=1
#SBATCH --ntasks=1 # Number of cores
#SBATCH --mem=9G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -J gwss_filt_blob2


module unload miniconda2
module load miniconda3

module load db-ncbi
module load db-uniprot


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


OUTDIR=noteuk

mkdir -p noteuk

blobtools filter \
 --param bestsumorder_superkingdom--Keys=Eukaryota \
 --fasta $ASSEMBLY \
 --output $OUTDIR \
 --invert \
 $PREFIX





    
