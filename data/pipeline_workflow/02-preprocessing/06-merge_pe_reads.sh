#!/bin/bash 
#SBATCH --job-name=merge_pe_reads   #nome do job
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

### Merge Paired-End Reads
for run in $runs
do
    fastp -i "$removal"/unaligned_1_"$run".fastq -I "$removal"/unaligned_2_"$run".fastq -o "$trimmed"/unassembled_1_"$run".fastq -O "$trimmed"/unassembled_2_"$run".fastq -q 20 -w 32 --detect_adapter_for_pe -h "$trimmed"/report2_"$run".html -j "$trimmed"/fastp2_"$run".json -m --merged_out "$assembled"/"$run"_assembled.fastq
    rm "$removal"/unaligned_1_"$run".fastq
    rm "$removal"/unaligned_2_"$run".fastq
    rm "$trimmed"/unassembled_1_"$run".fastq
    rm "$trimmed"/unassembled_2_"$run".fastq
    echo "########## FINAL - "$run" ##########"
done
echo "##### Merge Paired-End Reads - FINISHED #####"

