#!/bin/bash
##
#SBATCH -o /rhome/cassande/bigdata/GWSS/GWSS_Genome/GWSS_scaffold/scaffold_vs_i5k/busco.log.txt
#SBATCH -e /rhome/cassande/bigdata/GWSS/GWSS_Genome/GWSS_scaffold/scaffold_vs_i5k/busco.log.txt
#SBATCH --nodes=1
#SBATCH --ntasks=12 # Number of cores
#SBATCH --mem=60G # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --time=24:00:00
#SBATCH -D /rhome/cassande/bigdata/GWSS/GWSS_Genome/GWSS_scaffold/scaffold_vs_i5k/
#SBATCH -J gwss_busco
#SBATCH --mail-type=END # notifications for job done & fail
#SBATCH --mail-user=cassande@ucr.edu # send-to address

module load busco/4.0.5

busco -i data/Homalodisca_vitripennis.A6A7A9_masurca_v1.sorted.fasta -l eukaryota_odb10 -o busco_results/busco_euk_masurca -m genome 

busco -i ragtag_correct_scaffolds/Homalodisca_vitripennis.A6A7A9_masurca_v1.sorted.corrected.fasta -l eukaryota_odb10 -o busco_results/busco_euk_masurca_ragtag_corrected -m genome 

busco -i data/masurca.A6_A7_A9.flye.assembly.fasta -l eukaryota_odb10 -o busco_results/busco_euk_flye_contigs -m genome 

busco -i ragtag_scaffold_contigs/ragtag.scaffolds.fasta -l eukaryota_odb10 -o busco_results/busco_euk_flye_ragtag -m genome 

busco -i data/GCA_000696855.2_Hvit_2.0_genomic.fna -l eukaryota_odb10 -o busco_results/busco_euk_i5k -m genome 

busco -i data/Homalodisca_vitripennis.A6A7A9_masurca_v1.sorted.fasta -l hemiptera_odb10 -o busco_results/busco_hem_masurca -m genome 

busco -i ragtag_correct_scaffolds/Homalodisca_vitripennis.A6A7A9_masurca_v1.sorted.corrected.fasta -l hemiptera_odb10 -o busco_results/busco_hem_masurca_ragtag_corrected -m genome 

busco -i data/masurca.A6_A7_A9.flye.assembly.fasta -l hemiptera_odb10 -o busco_results/busco_hem_flye_contigs -m genome 

busco -i ragtag_scaffold_contigs/ragtag.scaffolds.fasta -l hemiptera_odb10 -o busco_results/busco_hem_flye_ragtag -m genome 

busco -i data/GCA_000696855.2_Hvit_2.0_genomic.fna -l hemiptera_odb10 -o busco_results/busco_hem_i5k -m genome 


