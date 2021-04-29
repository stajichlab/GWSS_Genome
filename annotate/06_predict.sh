#!/bin/bash
#SBATCH -p batch
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --mem 50G 
#SBATCH --time=4-00:00:00
#SBATCH --output=logs/train.%a.log
#SBATCH -J gwss_predict
#SBATCH --array 1

export PATH="/opt/linux/centos/7.x/x86_64/pkgs/genemarkESET/4.59_lic:$PATH"

# Define program name
PROGNAME=$(basename $0)
hostname
# Load software
#source /etc/profile.d/modules.sh

module load funannotate/1.8.0
source activate funannotate-1.8


CPU=1
if [ $SLURM_CPUS_ON_NODE ]; then
    CPU=$SLURM_CPUS_ON_NODE
fi

BUSCO=hemiptera_odb10
INDIR=genomes
OUTDIR=annotate
PREDS=$(realpath prediction_support)
mkdir -p $OUTDIR
SAMPFILE=genomes/samples.csv
N=${SLURM_ARRAY_TASK_ID}

if [ ! $N ]; then
    N=$1
    if [ ! $N ]; then
        echo "need to provide a number by --array or cmdline"
        exit
    fi
fi
MAX=`wc -l $SAMPFILE | awk '{print $1}'`

if [ $N -gt $MAX ]; then
    echo "$N is too big, only $MAX lines in $SAMPFILE"
    exit
fi

#export SINGULARITY_BINDPATH=/bigdata,/bigdata/operations/pkgadmin/opt/linux:/opt/linux
export AUGUSTUS_CONFIG_PATH=$(realpath lib/augustus/3.3/config)

export FUNANNOTATE_DB=/bigdata/stajichlab/shared/lib/funannotate_db
# make genemark key link required to run it
if [ ! -s ~/.gm_key ]; then
	module  load    genemarkESET/4.38
	GMFOLDER=`dirname $(which gmhmme3)`
  ln -s $GMFOLDER/.gm_key ~/.gm_key
  module unload genemarkESET
fi
#export GENEMARK_PATH=/opt/genemark/gm_et_linux_64
module unload perl
#module list
which perl
which diamond

module unload diamond/2.0.6
module load diamond/2.0.4

SEQCENTER=UCRiverside
IFS=,
SEED_SPECIES=fly
tail -n +2 $SAMPFILE | sed -n ${N}p | while read SPECIES INFO BIOSAMPLE BIOPROJECT SRA LOCUSTAG
do
    BASE=$(echo -n "${SPECIES}.$INFO" | perl -p -e 's/\s+/_/g')
    echo "sample is $BASE"
    MASKED=$(realpath $INDIR/$BASE.masked.fasta)
    if [ ! -f $MASKED ]; then
      echo "Cannot find $BASE.masked.fasta in $INDIR - may not have been run yet"
      exit
    fi
   echo "looking for $MASKED to run"
   echo "LOCUSTAG IS '$LOCUSTAG'"
# is this temp folder still needed?
    mkdir $BASE.predict.$$
    pushd $BASE.predict.$$
    funannotate predict --cpus $CPU --keep_no_stops --SeqCenter $SEQCENTER --busco_db $BUSCO --optimize_augustus \
        --min_training_models 200 --AUGUSTUS_CONFIG_PATH $AUGUSTUS_CONFIG_PATH \
        -i ../$INDIR/$BASE.masked.fasta --name $LOCUSTAG  --weights codingquarry:0 \
        -s "$SPECIES"  -o ../$OUTDIR/$BASE --busco_seed_species $SEED_SPECIES
    popd
    rmdir $BASE.predict.$$
done
