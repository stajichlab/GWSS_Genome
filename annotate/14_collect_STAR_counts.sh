#!/usr/bin/bash
#SBATCH -p short --mem 24gb -N 1 -n 16 --out logs/STARfeatureCounts.log
#SBATCH -J gwss_STAR_counts

INDIR=data/UCR_2019_samples
OUTDIR=results/STAR
IDX=data/STAR
SAMPLEFILE=samples.tsv
GENOME=$(realpath data/Homalodisca_vitripennis.A6A7A9_masurca_v1_ragtag_v1.masked.fasta)
GFF=$(realpath data/Homalodisca_vitripennis_A6A7A9_masurca_v1_ragtag_v1.gff3)
GTF=Homalodisca_vitripennis_A6A7A9_masurca_v1_ragtag_v1.gtf
module load subread

CPU=1
if [ $SLURM_CPUS_ON_NODE ]; then
    CPU=$SLURM_CPUS_ON_NODE
fi


if [ ! -s $OUTDIR/STAR_featureCounts.tsv ]; then
  featureCounts -a $GTF -o $OUTDIR/STAR_featureCounts.tsv -G $GENOME -J -g gene_id -F GTF $(find $OUTDIR -size +0 -name "*.Aligned.sortedByCoord.out.bam")
fi
