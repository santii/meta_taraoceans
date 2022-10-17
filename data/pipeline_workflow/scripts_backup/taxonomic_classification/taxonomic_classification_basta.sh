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

