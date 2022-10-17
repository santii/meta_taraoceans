#!/bin/bash 
#SBATCH --job-name=taxonomic_analysis   #nome do job
#SBATCH --time=20-0:00	#tempo limite de execucao

#SBATCH --nodes=1	#número de nós
#SBATCH --mem=128000	#quantidade total de memoria
#SBATCH --qos=qos2	#tipo de multiplos jobs
#SBATCH --exclusive	#no exclusivo
 
#SBATCH --mail-user=bianca.santiago72@gmail.com
#SBATCH --mail-type=ALL


######################################################################################################################################################################################################

### Ativando o protocolMeta
#set +eu
#PS1=dummy
#. $(conda info --base)/etc/profile.d/conda.sh
#conda activate protocolMeta

######################################################################################################################################################################################################


### Declarando variaveis

runs="ERR599026
ERR594324
ERR594321
ERR594336
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
kaiju="/home/bcfsantiago/master_degree/dbs/kaiju"
######################################################################################################################################################################################################

### Necessario somente no super computador
#module load libraries/glibc/2.14-pre-comp

######################################################################################################################################################################################################

### Divisão Taxonômica

cd "$taxonomic"

#Modelo: kaiju -t kaiju/nodes.dmp -f kaiju/kaiju_db_nr.fmi -i benchmark/sim1.fastq -o benchmark/kaiju.out -z 64
#Modelo: kaiju-addTaxonNames -t kaiju/nodes.dmp -n kaiju/names.dmp -r superkingdom,phylum,class,order,family,genus,species -i benchmark/kaiju.out -o benchmark/kaiju.names.out

for run in $runs
do
    kaiju -t "$kaiju"/nodes.dmp -f "$kaiju"/kaiju_db_nr.fmi -i "$collapsed"/"$run".fasta -o "$taxonomic"/"$run"_kaiju.out -z 64
    kaiju-addTaxonNames -t "$kaiju"/nodes.dmp -n "$kaiju"/names.dmp -r superkingdom,phylum,class,order,family,genus,species -i "$taxonomic"/"$run"_kaiju.out -o "$taxonomic"/"$run"_kaiju.names.out
    awk -F "\t" '{if($1 == "C") {print}}'
    "$taxonomic"/"$run"_kaiju.names.out > "$taxonomic"/"$run"_kaiju.names_filtrado.txt
    echo "########## FINAL da "$run" ##########"
done

echo "##### Divisão Taxonômica - FINALIZADO #####"


