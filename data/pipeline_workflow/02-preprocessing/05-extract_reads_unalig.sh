#!/bin/bash 
#SBATCH --job-name=extract_reads_unalig   #nome do job
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

### Extract Reads Unaligned	
for run in $runs
do
    samtools view -bS "$removal"/all_"$run".sam > "$removal"/all_"$run".bam
    rm "$removal"/all_"$run".sam
    echo "########## FINAL - all_"$run".sam > all_"$run".bam ##########"
    samtools view -b -f 12 -F 256 "$removal"/all_"$run".bam > "$removal"/unaligned_"$run".bam
    rm "$removal"/all_"$run".bam
    echo "########## FINAL - all_"$run".bam > unaligned_"$run".bam ##########"
    samtools sort -n "$removal"/unaligned_"$run".bam -o "$removal"/unaligned_sorted_"$run".bam
    rm "$removal"/unaligned_"$run".bam
    echo "########## FINAL - unaligned_"$run".bam > unaligned_sorted_"$run".bam ##########"
    samtools bam2fq "$removal"/unaligned_sorted_"$run".bam > "$removal"/unaligned_"$run".fastq
    rm "$removal"/unaligned_sorted_"$run".bam
    echo "########## FINAL - unaligned_sorted_"$run".bam > unaligned_"$run".fastq ##########"
    cat "$removal"/unaligned_"$run".fastq | grep '^@.*/1$' -A 3 --no-group-separator > "$removal"/unaligned_1_"$run".fastq
    echo "########## FINAL - unaligned_"$run".fastq > "$removal"/unaligned_1_"$run".fastq ##########"
    cat "$removal"/unaligned_"$run".fastq | grep '^@.*/2$' -A 3 --no-group-separator > "$removal"/unaligned_2_"$run".fastq
    echo "########## FINAL - unaligned_"$run".fastq > "$removal"/unaligned_2_"$run".fastq ##########"
    rm "$removal"/unaligned_"$run".fastq
    echo "########## FINAL - "$run" ##########"
done
echo "##### Extract Reads Unaligned - FINISHED #####"

