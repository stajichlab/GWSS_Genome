#!/bin/bash
#SBATCH --ntasks 24 --nodes 1 --mem 96G -p intel 
#SBATCH --time 72:00:00 --out logs/iprscan.%a.reorder.log
#SBATCH -J gwss_iprscn
#SBATCH --array 1


module load funannotate/1.8
source activate funannotate-1.8
module load iprscan


CPU=1
if [ ! -z $SLURM_CPUS_ON_NODE ]; then
    CPU=$SLURM_CPUS_ON_NODE
fi
OUTDIR=annotate
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
IFS=,
tail -n +2 $SAMPFILE | sed -n ${N}p | while read SPECIES STRAIN BIOSAMPLE BIOPROJECT SRA LOCUSTAG
do
    	BASE=$(echo -n "$SPECIES.$STRAIN" | perl -p -e 's/\s+/_/g')
    	STRAIN_NOSPACE=$(echo -n "$STRAIN" | perl -p -e 's/\s+/_/g')
    	echo "$BASE"
	 if [ ! -d $OUTDIR/$name ]; then
		echo "No annotation dir for ${name}"
		exit
 	fi
	mkdir -p $OUTDIR/$BASE/annotate_misc
	XML=$OUTDIR/$BASE/annotate_misc/iprscan.xml
	IPRPATH=$(which interproscan.sh)
	if [ ! -f $XML ]; then
	    funannotate iprscan -i $OUTDIR/$BASE -o $XML -m local -c $CPU --iprscan_path $IPRPATH
	fi
done
