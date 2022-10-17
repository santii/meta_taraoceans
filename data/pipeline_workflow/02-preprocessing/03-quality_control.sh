#!/bin/bash 
#SBATCH --job-name=quality_control   #nome do job
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

### Quality Control	
for run in $runs
do
    fastp -i "$run"_1.fastq -I "$run"_2.fastq -o "$trimmed"/"$run"_1_trim.fastq -O "$trimmed"/"$run"_2_trim.fastq -q 20 -w 32 --detect_adapter_for_pe -h "$trimmed"/report_"$run".html -j "$trimmed"/fastp_"$run".json
    rm "$run"_1.fastq
    rm "$run"_2.fastq
    echo "########## FINAL - "$run" ##########"
done	
echo "##### Quality Control - FINISHED #####"

