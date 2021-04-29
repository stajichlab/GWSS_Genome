#!/usr/bin/bash
#SBATCH -p intel,batch --mem 32gb -N 1 -n 8 --out logs/STARindex.%a.log
#SBATCH -J gwss_index

module load samtools/1.11
module load bwa/0.7.17

if [ -f config.txt ]; then
	source config.txt
fi


if [[ ! -f $REFGENOME.fai || $$REFGENOME -nt $REFGENOME.fai ]]; then
	samtools faidx $REFGENOME
fi
if [[ ! -f $REFGENOME.bwt || $REFGENOME -nt $REFGENOME.bwt ]]; then
	bwa index $REFGENOME
fi


DICT=$(basename $REFGENOME .fasta)".dict"

if [[ ! -f $DICT || $REFGENOME -nt $DICT ]]; then
	rm -f $DICT
	samtools dict $REFGENOME > $DICT
	ln -s $DICT $REFGENOME.dict 
fi

popd
