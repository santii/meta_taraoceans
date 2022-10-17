#!/bin/bash 
#SBATCH --job-name=functional_annotation   #nome do job
#SBATCH --time=0-5:59	#tempo limite de execucao

#SBATCH --nodes=1	#número de nós
#SBATCH --mem=128000	#quantidade total de memoria
#SBATCH --qos=qos2	#tipo de multiplos jobs
#SBATCH --exclusive	#no exclusivo
 
#SBATCH --mail-user=bianca.santiago72@gmail.com
#SBATCH --mail-type=ALL

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
ERR598961
ERR599042
ERR599079"

url="ftp://ftp.sra.ebi.ac.uk/vol1/fastq/"
slash="/"

local_address="/storages/acari/santi/master_degree/taraocean/"
protocol="/storages/acari/santi/master_degree/taraocean/Protocol"
alignment="/storages/acari/santi/master_degree/taraocean/Protocol/alignment"
data="/storages/acari/santi/master_degree/taraocean/Protocol/data"
functional="/storages/acari/santi/master_degree/taraocean/Protocol/functional"
db_func="/storages/acari/santi/master_degree/taraocean/Protocol/functional/db"
taxonomic="/storages/acari/santi/master_degree/taraocean/Protocol/taxonomic"
db="/storages/acari/santi/master_degree/taraocean/Protocol/alignment/db"
index_alig="/storages/acari/santi/master_degree/taraocean/Protocol/alignment/index"
raw="/storages/acari/santi/master_degree/taraocean/Protocol/data/raw"
assembled="/storages/acari/santi/master_degree/taraocean/Protocol/data/assembled"
collapsed="/storages/acari/santi/master_degree/taraocean/Protocol/data/collapsed"
removal="/storages/acari/santi/master_degree/taraocean/Protocol/data/removal"    
trimmed="/storages/acari/santi/master_degree/taraocean/Protocol/data/trimmed"
index_remo="/storages/acari/santi/master_degree/taraocean/Protocol/data/removal/index"
reference="/storages/acari/santi/master_degree/taraocean/Protocol/data/removal/reference"
temp_analysis="/storages/acari/santi/master_degree/taraocean/Protocol/data/temp_analysis"

index_remo_diego="/scratch/global/dadamorais/Protocol/data/removal/index/hs102"
index_alig_diego="/scratch/global/dadamorais/Protocol/alignment/index/nr160121"

######################################################################################################################################################################################################

cd $functional

### Anotacao Funcional

#Modelo: annotate idmapping diamond.m8 outputFunctional.txt NR2GO

 
for run in $runs
do
    annotate idmapping "$alignment$slash"matches_"$run".m8 outputFunctional_"$run".txt NR2GO -d $db_func
    echo "##### FINAL DA $run #####"
done

echo "##### Anotacao Funcional - FINALIZADO #####"

######################################################################################################################################################################################################

