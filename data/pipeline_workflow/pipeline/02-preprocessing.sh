#!/bin/bash 
#SBATCH --job-name=preprocessing   #nome do job
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

############################################################ Quality Control ############################################################
	
for run in $runs
do
    fastp -i "$run"_1.fastq -I "$run"_2.fastq -o "$trimmed"/"$run"_1_trim.fastq -O "$trimmed"/"$run"_2_trim.fastq -q 20 -w 32 --detect_adapter_for_pe -h "$trimmed"/report_"$run".html -j "$trimmed"/fastp_"$run".json
    rm "$run"_1.fastq
    rm "$run"_2.fastq
    echo "########## FINAL - "$run" ##########"
done	
echo "##### Quality Control - FINISHED #####"

echo "####################################################################################################################################################################################"
	
############################################################ Alignment With Reference Genome ############################################################

for run in $runs
do
    bowtie2 -x $index_remo -1 "$trimmed"/"$run"_1_trim.fastq -2 "$trimmed"/"$run"_2_trim.fastq -S "$removal"/all_"$run".sam -p 32
    rm "$trimmed"/"$run"_1_trim.fastq
    rm "$trimmed"/"$run"_2_trim.fastq
    echo "########## FINAL - all_"$run".sam ##########"
done
echo "##### Alignment With Reference Genome - FINISHED #####"

echo "####################################################################################################################################################################################"

############################################################ Extract Reads Unaligned ############################################################

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

echo "####################################################################################################################################################################################"

############################################################ Merge Paired-End Reads ############################################################

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

echo "####################################################################################################################################################################################"

############################################################ Remove Duplicate Sequences ############################################################

for run in $runs
do
    fastx_collapser -i "$assembled"/"$run"_assembled.fastq -o "$collapsed"/"$run".fasta
    rm "$assembled"/"$run"_assembled.fastq
    echo "########## FINAL - "$run" ##########"
done
echo "##### Remove Duplicate Sequences - FINISHED #####"

echo "####################################################################################################################################################################################"

