#!/bin/bash -l
#
#SBATCH -n 24 #number cores
#SBATCH -p intel,batch
#SBATCH -e /logs/checkm.txt
#SBATCH -o /logs/checkm.txt
#SBATCH -J checkm_gwss
#SBATCH --mem 96G #memory in Gb
#SBATCH -t 96:00:00 #time in hours:min:sec


module load checkm

BINFOLDER=/Homalodisca_vitripennis.A6A7A9_masurca_v1_ragtag_v1.profile/SUMMARY_taxa/bin_fastas
OUTPUT=gwss_endo_checkm
CPU=24

checkm lineage_wf -t $CPU -x fa $BINFOLDER $OUTPUT

checkm tree $BINFOLDER -x .fa -t $CPU $OUTPUT/tree

checkm tree_qa $OUTPUT/tree -f $OUTPUT/$OUTPUT.checkm.txt

