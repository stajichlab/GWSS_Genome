#!/usr/bin/bash
#SBATCH -p intel,batch
#SBATCH -o /logs/cov.log.contam.txt
#SBATCH -e /logs/cov.log.contam.txt
#SBATCH --nodes=1
#SBATCH --ntasks=24 # Number of cores
#SBATCH --mem=48G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -J gwss_blob_cov_jbrowse

module unload miniconda2
module load bwa
module load samtools/1.11
module load bedtools
module load miniconda3
module load blobtools
source activate blobtools

DIR=data
COV=contam_investigate
PREFIX=HV_contam
READS=FB_A6_S35_L001_R


CPU=1
if [ $SLURM_CPUS_ON_NODE ]; then
 CPU=$SLURM_CPUS_ON_NODE
fi

mkdir -p $COV


ASSEMBLY=${COV}/Homalodisca_vitripennis.scaffolds.removed.fasta
BAM=${COV}/$PREFIX.remap.bam
FWD=${DIR}/${READS}1_001.fastq.gz
REV=${DIR}/${READS}2_001.fastq.gz
COVTAB=$BAM.cov

	
bwa index $ASSEMBLY

bwa mem -t $CPU $ASSEMBLY $FWD $REV | samtools sort --threads $CPU -T /scratch -O bam -o $BAM
	
samtools index $BAM

    
