#!/bin/bash -l
#
#SBATCH --ntasks 16 #number cores
#SBATCH -J kaiju_gwss_avio
#SBATCH --mem=250G #memory
#SBATCH -p intel,batch
#SBATCH --time 2-0:0:0
#SBATCH -o /logs/02_kaiju.log
#SBATCH -e /logs/02_kaiju.log


DB=/bigdata/software/databases/kaiju
PREFIX=Homalodisca_vitripennis.A6A7A9_masurca_v1_ragtag_v1
CPU=16

module load kaiju

kaiju -z $CPU -t $DB/nodes.dmp -f $DB/kaiju_db_nr_euk.fmi -i $PREFIX.gene.calls.fa -o $PREFIX.kaiju.out -v

kaiju-addTaxonNames -t $DB/nodes.dmp -n $DB/names.dmp -i $PREFIX.kaiju.out -o $PREFIX.kaiju.names.out -r superkingdom,phylum,class,order,family,genus,species


module unload miniconda2
module unload anaconda3

module load miniconda3

source activate anvio-7

anvi-import-taxonomy-for-genes -i $PREFIX.kaiju.names.out -c $PREFIX.db -p kaiju --just-do-it



