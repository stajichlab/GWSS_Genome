#!/usr/bin/bash
#SBATCH -p stajichlab 
#SBATCH -N 1 
#SBATCH -n 64 
#SBATCH --mem 96gb 
#SBATCH --out logs/rmodel.log
#SBATCH -J gwss_repeat

CPU=$SLURM_CPUS_ON_NODE # set the CPUS dynamicall for the job
if [ -z $CPU ]; then # unless this is not really a slurm job
 CPU=2 # set the number of CPUs to 2
fi

module unload miniconda2
module load miniconda3
module load funannotate
module load RepeatModeler/2.0.1

SPECIES=gwss

if [ ! -f $SPECIES.translation ]; then # assumes using rmblast as default
  BuildDatabase -name $SPECIES $SPECIES.A6A7A9_masurca.ragtag.scaffolds.vecscreen.sorted.fasta
fi

# this can take 2-48 hrs depending on genome size - you may need to set job running
RepeatModeler -database $SPECIES -LTRStruct -pa $CPU

