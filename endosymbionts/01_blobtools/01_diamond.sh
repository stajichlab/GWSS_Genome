#!/usr/bin/bash
#SBATCH -p intel,batch
#SBATCH -o /logs/diamond.log.txt
#SBATCH -e /logs/diamond.log.txt
#SBATCH --nodes=1
#SBATCH --ntasks=24 # Number of cores
#SBATCH --mem=128G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -J gwss_blob_diamond


module unload miniconda2
module load miniconda3
module load diamond/2.0.4
module load blobtools
source activate blobtools
DB=/srv/projects/db/blobPlotDB/2020_10/uniprot_ref_proteomes.diamond.dmnd
ASMDIR=data
CPU=1
COV=coverage
PREFIX=Homalodisca_vitripennis.A6A7A9_masurca_v1_ragtag

TAXFOLDER=taxonomy
mkdir -p $TAXFOLDER


ASSEMBLY=$(realpath ${ASMDIR}/$PREFIX.sorted.fasta)

diamond blastx \
	--query $ASSEMBLY \
	--db $DB -c1 --tmpdir /scratch \
	--outfmt 6 \
	--sensitive \
	--max-target-seqs 1 \
	--evalue 1e-25 --threads $CPU \
	--out $TAXFOLDER/$PREFIX.diamond.tab

blobtools taxify -f $TAXFOLDER/$PREFIX.diamond.tab \
	-m /srv/projects/db/blobPlotDB/2020_10/uniprot_ref_proteomes.taxids \
	-s 0 -t 2 -o $TAXFOLDER/






