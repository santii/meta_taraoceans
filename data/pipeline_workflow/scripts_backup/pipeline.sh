#!/bin/bash 
#SBATCH --job-name=taxonomic_analysis   #nome do job
#SBATCH --time=0-5:59	#tempo limite de execucao

#SBATCH --nodes=1	#número de nós
#SBATCH --mem=128000	#quantidade total de memoria
#SBATCH --qos=qos2	#tipo de multiplos jobs
#SBATCH --exclusive	#no exclusivo
 
#SBATCH --mail-user=bianca.santiago72@gmail.com
#SBATCH --mail-type=ALL


######################################################################################################################################################################################################

### Ativando o protocolMeta
set +eu
PS1=dummy
. $(conda info --base)/etc/profile.d/conda.sh
conda activate protocolMeta

######################################################################################################################################################################################################


### Declarando variaveis

runs="ERR599026
ERR594324
ERR598972
ERR599023
ERR599025
ERR594385
ERR599040
ERR599148
ERR594321
ERR594298
ERR594355
ERR599046
ERR599101
ERR594336
ERR594303
ERR598965
ERR598961"

url="ftp://ftp.sra.ebi.ac.uk/vol1/fastq/"
slash="/"

local_address="/home/bcfsantiago/master_degree/taraocean/"
protocol="/home/bcfsantiago/master_degree/taraocean/Protocol"
alignment="/home/bcfsantiago/master_degree/taraocean/Protocol/alignment"
data="/home/bcfsantiago/master_degree/taraocean/Protocol/data"
functional="/home/bcfsantiago/master_degree/taraocean/Protocol/functional"
taxonomic="/home/bcfsantiago/master_degree/taraocean/Protocol/taxonomic"
db="/home/bcfsantiago/master_degree/taraocean/Protocol/alignment/db"
index_alig="/home/bcfsantiago/master_degree/taraocean/Protocol/alignment/index"
assembled="/home/bcfsantiago/master_degree/taraocean/Protocol/data/assembled"
collapsed="/home/bcfsantiago/master_degree/taraocean/Protocol/data/collapsed"
removal="/home/bcfsantiago/master_degree/taraocean/Protocol/data/removal"    
trimmed="/home/bcfsantiago/master_degree/taraocean/Protocol/data/trimmed"
index_remo="/home/bcfsantiago/master_degree/taraocean/Protocol/data/removal/index"
reference="/home/bcfsantiago/master_degree/taraocean/Protocol/data/removal/reference"
temp_analysis="/home/bcfsantiago/master_degree/taraocean/Protocol/data/temp_analysis"
index_remo_diego="/scratch/global/dadamorais/Protocol/data/removal/index/hs102"
index_alig_diego="/scratch/global/dadamorais/Protocol/alignment/index/nr160121"
index_general_dbs="/home/bcfsantiago/master_degree/dbs/bastadb"

######################################################################################################################################################################################################
									########## PREPROCESSING ##########
######################################################################################################################################################################################################

#cd $temp_analysis

### Baixando amostras

#Modelo: wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR599/ERR599095/ERR599095_1.fastq.gz

#for run in $runs
#do
#    sixchar=${run:0:6}
#    wget "$url$sixchar$slash$run$slash$run"_1.fastq.gz
#    wget "$url$sixchar$slash$run$slash$run"_2.fastq.gz
#done

#echo "##### Baixando amostras - FINALIZADO #####"

######################################################################################################################################################################################################

### Verificando dados baixados

#Modelo: vdb-validate SRR579292/SRR579292.sra

#for run in $runs
#do
#    vdb-validate "$run$slash$run".sra
#done  

#echo "##### Verificando dados baixados - FINALIZADO #####" 

######################################################################################################################################################################################################
	
### Obtendo pair-end reads

#Modelo: fasterq-dump SRR579292
	
#for run in $runs
#do
#    fasterq-dump $run
#done 

#echo "##### Obtendo pair-end reads - FINALIZADO #####" 

######################################################################################################################################################################################################

### Extraindo pair-end reads

#Modelo0: gunzip SRR579292_1.fastq.gz
#Modelo: pigz -d Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz -p 8	

#for run in $runs
#do
#    gunzip "$run"_1.fastq.gz
#    gunzip "$run"_2.fastq.gz
#done 

for run in $runs
do
    pigz -d "$run"_1.fastq.gz -p 32
    pigz -d "$run"_2.fastq.gz -p 32
done

echo "##### Extraindo pair-end reads - FINALIZADO #####"

######################################################################################################################################################################################################

### Removendo sequencias e adaptadores de baixa qualidade

#Modelo: fastp -i SRR579292_1.fastq -I SRR579292_2.fastq -o trimmed/SRR579292_1_trim.fastq -O trimmed/SRR579292_2_trim.fastq -q 20 -w 8 --detect_adapter_for_pe -h trimmed/report.html -j trimmed/fastp.json
	
for run in $runs
do
    fastp -i "$run"_1.fastq -I "$run"_2.fastq -o "$trimmed$slash$run"_1_trim.fastq -O "$trimmed$slash$run"_2_trim.fastq -q 20 -w 32 --detect_adapter_for_pe -h "$trimmed"/report_"$run".html -j "$trimmed"/fastp_"$run".json
done	

echo "##### Removendo sequencias e adaptadores de baixa qualidade - FINALIZADO #####"

######################################################################################################################################################################################################

### Alinhando as sequencias com o genoma referencia 

#Modelo: bowtie2 -x removal/index/host -1 trimmed/SRR579292_1_trim.fastq -2 trimmed/SRR579292_2_trim.fastq -S removal/all.sam -p 8

for run in $runs
do
    bowtie2 -x $index_remo_diego -1 "$trimmed$slash$run"_1_trim.fastq -2 "$trimmed$slash$run"_2_trim.fastq -S "$removal"/all_"$run".sam -p 32
done

echo "##### Alinhando as sequencias com o genoma referencia - FINALIZADO #####"

######################################################################################################################################################################################################

### Extraindo reads nao alinhadas 

#Modelo:samtools view -bS removal/all.sam > removal/all.bam
#Modelo: samtools view -b -f 12 -F 256 removal/all.bam > removal/unaligned.bam
#Modelo: samtools sort -n removal/unaligned.bam -o removal/unaligned_sorted.bam
#Modelo: samtools bam2fq removal/unaligned_sorted.bam > removal/unaligned.fastq
#Modelo: cat removal/unaligned.fastq | grep '^@.*/1$' -A 3 --no-group-separator > removal/unaligned_1.fastq
#Modelo: cat removal/unaligned.fastq | grep '^@.*/2$' -A 3 --no-group-separator > removal/unaligned_2.fastq

for run in $runs
do
    samtools view -bS "$removal"/all_"$run".sam > "$removal"/all_"$run".bam
    samtools view -b -f 12 -F 256 "$removal"/all_"$run".bam > "$removal"/unaligned_"$run".bam
    samtools sort -n "$removal"/unaligned_"$run".bam -o "$removal"/unaligned_sorted_"$run".bam
    samtools bam2fq "$removal"/unaligned_sorted_"$run".bam > "$removal"/unaligned_"$run".fastq
    cat "$removal"/unaligned_"$run".fastq | grep '^@.*/1$' -A 3 --no-group-separator > "$removal"/unaligned_1_"$run".fastq
    cat "$removal"/unaligned_"$run".fastq | grep '^@.*/2$' -A 3 --no-group-separator > "$removal"/unaligned_2_"$run".fastq
done

echo "##### Extraindo reads nao alinhadas - FINALIZADO #####"

######################################################################################################################################################################################################

### Combinando paired-end reads

#Modelo: fastp -i removal/unaligned_1.fastq -I removal/unaligned_2.fastq -o trimmed/unassembled_1.fastq -O trimmed/unassembled_2.fastq -q 20 -w 8 --detect_adapter_for_pe -h trimmed/report2.html -j trimmed/fastp2.json -m --merged_out assembled/SRR579292_assembled.fastq

for run in $runs
do
    fastp -i "$removal"/unaligned_1_"$run".fastq -I "$removal"/unaligned_2_"$run".fastq -o "$trimmed"/unassembled_1_"$run".fastq -O "$trimmed"/unassembled_2_"$run".fastq -q 20 -w 32 --detect_adapter_for_pe -h "$trimmed"/report2_"$run".html -j "$trimmed"/fastp2_"$run".json -m --merged_out "$assembled$slash$run"_assembled.fastq
done

echo "##### Combinando paired-end reads - FINALIZADO #####"

######################################################################################################################################################################################################

### Removendo sequencias duplicadas

#Modelo: fastx_collapser -i assembled/SRR579292_assembled.fastq -o collapsed/SRR579292.fasta

for run in $runs
do
    fastx_collapser -i "$assembled$slash$run"_assembled.fastq -o "$collapsed$slash$run".fasta
done

echo "##### Combinando paired-end reads - FINALIZADO #####"



######################################################################################################################################################################################################
									########## ALIGNMENT ##########
######################################################################################################################################################################################################

cd $alignment

### Alinhando as reads com o banco de dados de proteinas referencia

#Modelo: touch unaligned.fasta
#Modelo: diamond blastx -d index/nr -q ../data/collapsed/SRR579292.fasta -o matches.m8 --top 3 --un unaligned.fasta

for run in $runs
do
    touch unaligned_"$run".fasta
    diamond blastx -d $index_alig_diego -q "$collapsed$slash$run".fasta -o matches_"$run".m8 --top 3 --un unaligned_"$run".fasta -c 1 -b 5
done

echo "##### Alinhando as reads com o banco de dados de proteinas referencia - FINALIZADO #####"



######################################################################################################################################################################################################
									########## TAXONOMIC CLASSIFICATION ##########
######################################################################################################################################################################################################

### Necessario somente no super computador
module load libraries/glibc/2.14-pre-comp

### Realizando a classificacao taxonomica

cd $taxonomic

#Modelo: $ basta sequence ../alignment/all_matches.m8 basta_out.txt prot -l 1 -m 1 -b True
for run in $runs
do
    basta sequence "$alignment"/matches_"$run".m8 basta_out_"$run".txt -d $index_general_dbs prot -l 1 -m 1 -b True
done

echo "##### Realizando a classificacao taxonomica - FINALIZADO #####"

######################################################################################################################################################################################################

### Dividindo a saida em dois arquivos

#Modelo: awk -F "\t" '{print $1"\t"$2}' basta_out_"$run".txt > lca.txt
#Modelo: awk -F "\t" '{print $1"\t"$3}' basta_out_"$run".txt > best_hit.txt

for run in $runs
do
    awk -F "\t" '{print $1"\t"$2}' basta_out_"$run".txt > lca_"$run".txt
    awk -F "\t" '{print $1"\t"$3}' basta_out_"$run".txt > best_hit_"$run".txt
done

echo "##### Dividindo a saida em dois arquivos - FINALIZADO #####"

######################################################################################################################################################################################################

### Gerando os graficos Krona

for run in $runs
do
    basta2krona.py lca_"$run".txt lca_"$run".html
    basta2krona.py best_hit_"$run".txt best_hit_"$run".html
done

echo "##### Gerando os graficos Krona - FINALIZADO #####"



######################################################################################################################################################################################################
									########## FUNCTIONAL ANNOTATION ##########
######################################################################################################################################################################################################

