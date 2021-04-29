#!/usr/bin/bash
#SBATCH -p intel,batch
#SBATCH -o /logs/blast.log.txt
#SBATCH -e /logs/blast.log.txt
#SBATCH --nodes=1
#SBATCH --ntasks=24 # Number of cores
#SBATCH --mem=64G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH -J gwss_blob_blast


#get hits against nr


module unload miniconda2
module load miniconda3
module load blobtools
source activate blobtools

module load ncbi-blast
DB=/srv/projects/db/NCBI/preformatted/20190709/nt

ASSEMBLY=data/Homalodisca_vitripennis.A6A7A9_masurca_v1_ragtag.sorted.fasta
OUT=Homalodisca_vitripennis.A6A7A9_masurca_v1_ragtag
TAXFOLDER=taxonomy

CPU=1
if [ $SLURM_CPUS_ON_NODE ]; then
 CPU=$SLURM_CPUS_ON_NODE
fi


blastn \
 -query $ASSEMBLY \
 -db $DB \
 -outfmt '6 qseqid staxids bitscore std' \
 -max_target_seqs 10 \
 -max_hsps 1 -num_threads $CPU \
 -evalue 1e-25 -out $OUT.nt.blastn.tab



blobtools taxify -f $TAXFOLDER/$OUT.nt.blastn.tab \
	-m /srv/projects/db/blobPlotDB/2020_10/uniprot_ref_proteomes.taxids \
	-s 0 -t 2 -o $TAXFOLDER/

