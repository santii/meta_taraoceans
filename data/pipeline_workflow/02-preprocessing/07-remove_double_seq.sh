#!/bin/bash 
#SBATCH --job-name=remove_double_seq   #nome do job
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

#### Remove Duplicate Sequences
for run in $runs
do
    fastx_collapser -i "$assembled"/"$run"_assembled.fastq -o "$collapsed"/"$run".fasta
    rm "$assembled"/"$run"_assembled.fastq
    echo "########## FINAL - "$run" ##########"
done
echo "##### Remove Duplicate Sequences - FINISHED #####"

