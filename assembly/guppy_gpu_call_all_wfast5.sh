#!/usr/bin/bash
#SBATCH -p gpu --gres=gpu:p100:1 --mem=64gb --time=36:00:00 --out guppy_gpu.all.%A.log --ntasks 8 -N 1
mkdir -p logs
module load guppy/3.4.4-gpu
module load cuda

IN=fast5
OUT=guppy_fastq.3.4.4
OUT5=guppy_fast5.3.4.4

mkdir -p $OUT
if [ -z $CUDA_VISIBLE_DEVICES ]; then
	CUDA_VISIBLE_DEVICES=1
fi
echo $CUDA_VISIBLE_DEVICES
FLOWCELLNM=$(basename `pwd`)
FLOWCELL=$(echo $FLOWCELLNM | perl -p -e 'chomp; my @n = split(/_/,$_); $_=join("_",$n[-2],$n[-1])')
echo "FLOWCELL $FLOWCELL FOR $FLOWCELLNM"
guppy_basecaller -c dna_r9.4.1_450bps_hac.cfg -r -x "auto" \
    -s $OUT -i $IN --compress_fastq --num_callers 16 --fast5_out $OUT5 \
    --gpu_runners_per_device 24 --chunks_per_runner 900 --qscore_filtering --min_qscore 7 
#--device "cuda:$CUDA_VISIBLE_DEVICES" \
