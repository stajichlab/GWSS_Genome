#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --mem 650gb -p highmem
#SBATCH --time=7-00:15:00
#SBATCH --output=logs/train.%a.log
#SBATCH -J gwss_train
#SBATCH --array 1


hostname
# Load software
module load funannotate/1.8.0
source activate funannotate-1.8
module switch trinity-rnaseq/2.10.0
MEM=512G

#export SINGULARITY_BINDPATH=/bigdata,/bigdata/operations/pkgadmin/opt/linux:/opt/linux
export AUGUSTUS_CONFIG_PATH=$(realpath lib/augustus/3.3/config)
# Set some vars
export FUNANNOTATE_DB=/bigdata/stajichlab/shared/lib/funannotate_db
export PASAHOMEPATH=$(dirname `which Launch_PASA_pipeline.pl`)
export TRINITY=$(realpath `which Trinity`)
export TRINITYHOMEPATH=$(dirname $TRINITY)
export PASACONF=$(realpath ~/pasa.config.txt)

if [[ -z ${SLURM_CPUS_ON_NODE} ]]; then
    CPUS=1
else
    CPUS=${SLURM_CPUS_ON_NODE}
fi


N=${SLURM_ARRAY_TASK_ID}

if [ -z $N ]; then
    N=$1
    if [ -z $N ]; then
        echo "need to provide a number by --array or cmdline"
        exit
    fi
fi
ODIR=annotate
INDIR=genomes
#RNA=lib/RNASeq/PRJNA415461
RNA=lib/RNASeq/A1_RNA
SAMPLEFILE=genomes/samples.csv
IFS=,
#SPECIES,INFO,BIOSAMPLE,BIOPROJECT,SRA,LOCUSTAG

tail -n +2 $SAMPLEFILE | sed -n ${N}p | while read SPECIES STRAIN BIOSAMPLE BIOPROJECT SRA LOCUSTAG
do
    echo "SPECIES is $SPECIES"
    SPECIESNOSPACE=$(echo -n "$SPECIES" | perl -p -e 's/\s+/_/g')
    BASE=$(echo -n "$SPECIES.$STRAIN" | perl -p -e 's/\s+/_/g')
    echo "sample is $BASE"
    MASKED=$(realpath $INDIR/$BASE.masked.fasta)
    if [ ! -f $MASKED ]; then
	     echo "Cannot find $BASE.masked.fasta in $INDIR - may not have been run yet"
       exit
    fi

    echo $ODIR/$BASE/training
    funannotate train -i $MASKED -o $ODIR/$BASE \
   	--jaccard_clip --species "$SPECIES" --isolate $STRAIN \
  	--cpus $CPUS --memory $MEM --pasa_db mysql \
  	--left $RNA/left.fq.gz --right $RNA/right.fq.gz --stranded RF
done
