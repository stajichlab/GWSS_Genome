#!/bin/bash
#SBATCH -p batch,intel
#SBATCH --nodes 1 
#SBATCH --ntasks 8 
#SBATCH --mem 24gb 
#SBATCH --out /logs/parse.log
#SBATCH -e /logs/parse.log
#SBATCH -J gwss_mask_parse

module unload perl
module load perl/5.24.0

INPUT=mask_13518/RepeatMasker
SCRIPT=Parsing-RepeatMasker-Outputs 


perl $SCRIPT/parseRM.pl --in $INPUT --dir -p -l 50,1 -v 




