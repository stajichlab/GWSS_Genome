#!/bin/bash -l
#
#SBATCH --ntasks 16 #number cores
#SBATCH -o /logs/01_cov.log
#SBATCH -e /logs/01_cov.log
#SBATCH -J gwss_cov_anvio
#SBATCH --mem=48G #memory
#SBATCH -p intel,batch
#SBATCH --time 3-0:0:0

module unload miniconda2
module unload anaconda3

module load miniconda3

source activate anvio-7

PREFIX=Homalodisca_vitripennis.A6A7A9_masurca_v1_ragtag_v1
COVDIR=coverage
CPU=16
FREAD=FB_A6_S35_L001_R1_001.fastq.gz
RREAD=FB_A6_S35_L001_R2_001.fastq.gz

#get coverage info
bowtie2-build $PREFIX.fasta ${COVDIR}/$PREFIX

bowtie2 --threads $CPU -x  ${COVDIR}/$PREFIX -1 $FREAD -2 $RREAD -S ${COVDIR}/$PREFIX'.sam'

samtools view -F 4 -bS ${COVDIR}/$PREFIX'.sam' > ${COVDIR}/$PREFIX'-RAW.bam'

#set up anvio
anvi-init-bam ${COVDIR}/$PREFIX'-RAW.bam' -o ${COVDIR}/$PREFIX'.bam'

anvi-gen-contigs-database -f $PREFIX.fasta -o $PREFIX.db

anvi-run-hmms -c $PREFIX.db --num-threads $CPU

anvi-get-sequences-for-gene-calls -c $PREFIX.db -o $PREFIX.gene.calls.fa

anvi-get-sequences-for-gene-calls -c $PREFIX.db --get-aa-sequences -o $PREFIX.amino.acid.sequences.fa

#next steps
#get kaiju or similar taxonomy from gene calls and import back
#optional: get functional gene calls and import back
#then we need to use anvi-profile and run binning software
#if too big, can try eukrep first and re-run


