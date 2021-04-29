#!/bin/bash
#SBATCH -p batch 
#SBATCH --time 2-0:00:00
#SBATCH --nodes 1 
#SBATCH --ntasks 8 
#SBATCH --mem 24gb 
#SBATCH --out logs/mask.%a.log
#SBATCH -J gwss_mask_4
#SBATCH --array 1

CPU=1
if [ $SLURM_CPUS_ON_NODE ]; then
    CPU=$SLURM_CPUS_ON_NODE
fi

INDIR=genomes
OUTDIR=genomes_rep

SAMPFILE=genomes/samples.csv
N=${SLURM_ARRAY_TASK_ID}

if [ ! $N ]; then
    N=$1
    if [ ! $N ]; then
        echo "need to provide a number by --array or cmdline"
        exit
    fi
fi
MAX=$(wc -l $SAMPFILE | awk '{print $1}')
if [ $N -gt $(expr $MAX) ]; then
    MAXSMALL=$(expr $MAX)
    echo "$N is too big, only $MAXSMALL lines in $SAMPFILE"
    exit
fi

IFS=,
tail -n +2 $SAMPFILE | sed -n ${N}p | while read SPECIES INFO BIOPROJECT BIOSAMPLE SRA LOCUS
do
  name=$(echo -n "${SPECIES}.$INFO" | perl -p -e 's/\s+/_/g')
  if [ ! -f $INDIR/${name}.sorted.fasta ]; then
     echo "Cannot find $name in $INDIR - may not have been run yet"
     exit
  fi
  echo "$name"

  if [ ! -f $OUTDIR/${name}.masked.fasta ]; then
     module unload perl
     module unload python
     module unload miniconda2
     module unload miniconda3
     module load funannotate/development
     source activate funannotate
     export AUGUSTUS_CONFIG_PATH=$(realpath lib/augustus/3.3/config)
     if [ -f repeat_library/${name}.repeatmodeler-library_plusRepBase.fasta ]; then
	LIBRARY=$(realpath repeat_library/${name}.repeatmodeler-library_plusRepBase.fasta)
     elif [ -f repeat_library/${name}.repeatmodeler-library.fasta ]; then
    	  LIBRARY=$(realpath repeat_library/${name}.repeatmodeler-library.fasta)
     fi
     echo "LIBRARY is $LIBRARY"
     mkdir $name.mask.$$
     pushd $name.mask.$$
     if [ ! -z $LIBRARY ]; then
    	 funannotate mask --cpus $CPU -i ../$INDIR/${name}.sorted.fasta -o ../$OUTDIR/${name}.masked.fasta -l $LIBRARY --method repeatmodeler --debug
     else
       funannotate mask --cpus $CPU -i ../$INDIR/${name}.sorted.fasta -o ../$OUTDIR/${name}.masked.fasta --method repeatmodeler --debug
       mv repeatmodeler-library.*.fasta ../repeat_library/${name}.repeatmodeler-library.fasta
       mv funannotate-mask.log ../logs/masklog_long.$name.log
     fi
     popd
#     rmdir $name.mask.$$
  else
     echo "Skipping ${name} as masked already"
  fi
done
