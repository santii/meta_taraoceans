#!/bin/bash 
#SBATCH --job-name=database_index   #nome do job
#SBATCH --time=00-23:59	#tempo limite de execucao

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

### Necessario somente no super computador
module load libraries/glibc/2.14-pre-comp

### Copiando dados

diamond makedb --in /scratch/global/bcfsantiago/master_degree/taraocean/Protocol/alignment/db/nr -d /scratch/global/bcfsantiago/master_degree/taraocean/Protocol/alignment/index/nr
echo "##### Criando index alignment_banco - FINALIZADO #####"

# pigz -d /scratch/global/bcfsantiago/master_degree/taraocean/Protocol/alignment/db/nr.gz -p 8
# echo "##### Extraindo alignment_banco - FINALIZADO #####"

# cp /home/bcfsantiago/master_degree/taraocean/Protocol/alignment/db/nr.gz /scratch/global/bcfsantiago/master_degree/taraocean/Protocol/alignment/db
# echo "##### Copiando alignmentbanco - FINALIZADO #####"

# 
# cp /home/bcfsantiago/master_degree/taraocean/Protocol/data/temp_analysis/* /scratch/global/bcfsantiago/master_degree/taraocean/Protocol/data/temp_analysis
# echo "##### Copiando amostras - FINALIZADO #####"
# 
# cp /home/bcfsantiago/master_degree/taraocean/Protocol/data/assembled/ERR599042_assembled.fastq /scratch/global/bcfsantiago/master_degree/taraocean/Protocol/data/assembled
# echo "##### Copiando assembled - FINALIZADO #####"
# 
# cp /home/bcfsantiago/master_degree/taraocean/Protocol/data/collapsed/ERR599042.fasta /scratch/global/bcfsantiago/master_degree/taraocean/Protocol/data/collapsed
# echo "##### Copiando collapsed - FINALIZADO #####"
# 
# cp /home/bcfsantiago/master_degree/taraocean/Protocol/data/removal/all* /scratch/global/bcfsantiago/master_degree/taraocean/Protocol/data/removal
# cp /home/bcfsantiago/master_degree/taraocean/Protocol/data/removal/unaligned* /scratch/global/bcfsantiago/master_degree/taraocean/Protocol/data/removal
# echo "##### Copiando removal - FINALIZADO #####"
# 
# cp /home/bcfsantiago/master_degree/taraocean/Protocol/data/trimmed/ERR599042_1_trim.fastq /scratch/global/bcfsantiago/master_degree/taraocean/Protocol/data/trimmed
# cp /home/bcfsantiago/master_degree/taraocean/Protocol/data/trimmed/ERR599042_2_trim.fastq /scratch/global/bcfsantiago/master_degree/taraocean/Protocol/data/trimmed
# cp /home/bcfsantiago/master_degree/taraocean/Protocol/data/trimmed/fastp2_ERR599042.json /scratch/global/bcfsantiago/master_degree/taraocean/Protocol/data/trimmed
# cp /home/bcfsantiago/master_degree/taraocean/Protocol/data/trimmed/fastp_ERR599042.json /scratch/global/bcfsantiago/master_degree/taraocean/Protocol/data/trimmed
# cp /home/bcfsantiago/master_degree/taraocean/Protocol/data/trimmed/report2_ERR599042.html /scratch/global/bcfsantiago/master_degree/taraocean/Protocol/data/trimmed
# cp /home/bcfsantiago/master_degree/taraocean/Protocol/data/trimmed/report_ERR599042.html /scratch/global/bcfsantiago/master_degree/taraocean/Protocol/data/trimmed
# cp /home/bcfsantiago/master_degree/taraocean/Protocol/data/trimmed/unassembled_1_ERR599042.fastq /scratch/global/bcfsantiago/master_degree/taraocean/Protocol/data/trimmed
# cp /home/bcfsantiago/master_degree/taraocean/Protocol/data/trimmed/unassembled_2_ERR599042.fastq /scratch/global/bcfsantiago/master_degree/taraocean/Protocol/data/trimmed
# echo "##### Copiando trimmed - FINALIZADO #####"


echo "#########################################"
echo "##### Copiando tudo - FINALIZADO #####"
echo "#########################################"
######################################################################################################################################################################################################


