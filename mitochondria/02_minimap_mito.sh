#!/usr/bin/bash
#SBATCH -p intel,batch
#SBATCH -o /logs/log.minimap.txt
#SBATCH -e /logs/log.minimap.txt
#SBATCH --nodes=1
#SBATCH --ntasks=8 # Number of cores
#SBATCH --mem=24G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -J gwss_mito_map


module load minimap2

ASSEMBLY=data/Homalodisca_vitripennis.A6A7A9_masurca_v1_ragtag.sorted.fasta
RESULTS=results
MITO=data/gwss.mitogenome.fa
PREFIX=gwss.mitogenome

CPU=1
if [ $SLURM_CPUS_ON_NODE ]; then
 CPU=$SLURM_CPUS_ON_NODE
fi


minimap2 -ax asm5 $ASSEMBLY $MITO > ${RESULTS}/$PREFIX'.sam' 



#optional: convert sam to bam to visualize in jbrowse2

module load samtools

#fill in mate coords 
samtools fixmate -O bam ${RESULTS}/${PREFIX}.sam ${RESULTS}/${PREFIX}_fixmate.bam

#sort by left most coords
samtools sort --threads $CPU -O BAM -o ${RESULTS}/${PREFIX}.bam ${RESULTS}/${PREFIX}_fixmate.bam

#make bam file
samtools index ${RESULTS}/${PREFIX}_fixmate.bam

#get stats, will be printed to stdout, will try saving
samtools flagstat ${RESULTS}/${PREFIX}_fixmate.bam > ${RESULTS}/${PREFIX}_fixmate.stats.txt

#load bam files into jbrowse2
