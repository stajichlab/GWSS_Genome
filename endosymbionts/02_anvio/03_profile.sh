#!/bin/bash -l
#
#SBATCH --ntasks 16 #number cores
#SBATCH -J gwss_anvio_prof
#SBATCH --mem=250G #memory
#SBATCH -p intel,batch
#SBATCH --time 3-0:0:0
#SBATCH -o /logs/03_profile.log
#SBATCH -e /logs/03_profile.log


PREFIX=Homalodisca_vitripennis.A6A7A9_masurca_v1_ragtag_v1
COVDIR=coverage
CPU=16
MIN=2500


module unload miniconda2
module unload anaconda3
module load miniconda3

source activate anvio-7


#if we wanted we could do this in a loop via array - but here we only had one sample to profile so not needed
#this step can take a long time

anvi-profile -i ${COVDIR}/$PREFIX'.bam' -c $PREFIX.db --num-threads $CPU --min-contig-length $MIN --cluster-contigs --output-dir $PREFIX'.profile'


