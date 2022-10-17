#!/bin/bash 
#SBATCH --job-name=ref_gen_alig   #nome do job
#SBATCH --time=20-0:00	#tempo limite de execucao

#SBATCH --nodes=1	#número de nós
#SBATCH --mem=128000	#quantidade total de memoria
#SBATCH --qos=qos2	#tipo de multiplos jobs
#SBATCH --exclusive	#no exclusivo
 
#SBATCH --mail-user=bianca.santiago72@gmail.com
#SBATCH --mail-type=ALL

######################################################################################################################################################################################################

### Importing Variables
source ../00-default/00-var.sh

cd $raw
	
### Alignment With Reference Genome
for run in $runs
do
    bowtie2 -x $index_remo -1 "$trimmed"/"$run"_1_trim.fastq -2 "$trimmed"/"$run"_2_trim.fastq -S "$removal"/all_"$run".sam -p 32
    rm "$trimmed"/"$run"_1_trim.fastq
    rm "$trimmed"/"$run"_2_trim.fastq
    echo "########## FINAL - all_"$run".sam ##########"
done
echo "##### Alignment With Reference Genome - FINISHED #####"

