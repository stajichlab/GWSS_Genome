#!/usr/bin/bash
#SBATCH -p intel,batch,short
#SBATCH -o logs/jelly.range.log.txt
#SBATCH -e logs/jelly.range.log.txt
#SBATCH --nodes=1
#SBATCH --ntasks=16 # Number of cores
#SBATCH --mem=400G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -J gwss_jelly

module load jellyfish/2.3.0

KMERSET=kmer.txt


for kmer in $(cat $KMERSET);
do
	jellyfish count -C -m $kmer -s 2G -t 16 <(zcat FB_A6_S35_L001_R1_001.fastq.gz) <(zcat FB_A6_S35_L001_R2_001.fastq.gz) -o $kmer.Homalodisca_vitripennis.illumina_reads.jf

	jellyfish histo -t 16 $kmer.Homalodisca_vitripennis.illumina_reads.jf > $kmer.Homalodisca_vitripennis.illumina_reads.jf.histo

done
