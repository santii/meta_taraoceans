#!/bin/bash 
#SBATCH --job-name=alignment   #nome do job
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

cd $alignment

### Alignment of readings with the reference protein database
for run in $runs
do
    touch unaligned_"$run".fasta
    diamond blastx -d $index_alig -q "$collapsed"/"$run".fasta -o matches_"$run".m8 --top 3 --un unaligned_"$run".fasta -c 1 -b 5
    echo "########## FINAL - "$run" ##########"
done
echo "##### Alignment of readings with the reference protein database - FINISHED #####"

