#!/bin/bash 
#SBATCH --job-name=taxonomic_analysis   #nome do job
#SBATCH --time=12-0:00	#tempo limite de execucao

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

runs="ERR594336
ERR598965"

######################################################################################################################################################################################################

### Copiando entradas para o scratch/global

for run in $runs
do
    cp /home/bcfsantiago/master_degree/taraocean/Protocol/data/collapsed/"$run".fasta /scratch/global/bcfsantiago/master_degree/taraocean/Protocol/data/collapsed
done

### Diretorio alignment do scratch/global

cd /scratch/global/bcfsantiago/master_degree/taraocean/Protocol/alignment

### Alinhando as reads com o banco de dados de proteinas referencia

for run in $runs
do
    touch unaligned_"$run".fasta
    diamond blastx -d /scratch/global/dadamorais/Protocol/alignment/index/nr160121 -q /scratch/global/bcfsantiago/master_degree/taraocean/Protocol/data/collapsed/"$run".fasta -o matches_"$run".m8 --top 3 --un unaligned_"$run".fasta -c 1 -b 5
done

echo "##### Alinhando as reads com o banco de dados de proteinas referencia - FINALIZADO #####"

### Copiando as reads alinhadas para a pasta home

for run in $runs
do
    cp /scratch/global/bcfsantiago/master_degree/taraocean/Protocol/alignment/matches_"$run".m8 /home/bcfsantiago/master_degree/taraocean/Protocol/alignment
    cp /scratch/global/bcfsantiago/master_degree/taraocean/Protocol/alignment/unaligned_"$run".fasta /home/bcfsantiago/master_degree/taraocean/Protocol/alignment
done

echo "##### Copiando as reads alinhadas para a pasta home - FINALIZADO #####"
######################################################################################################################################################################################################

