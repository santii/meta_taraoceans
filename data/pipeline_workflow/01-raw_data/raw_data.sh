#!/bin/bash 
#SBATCH --job-name=01-raw_data   #nome do job
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

############################################################ Download Samples ############################################################

for run in $runs
do
    sixchar=${run:0:6}
    wget "$url$sixchar$slash$run$slash$run$one"
    echo "Final - "$run"_1"
    wget "$url$sixchar$slash$run$slash$run$two"
    echo "Final - "$run"_2"
    echo "##### FINAL - $run #####"
done
echo "##### DOWNLOAD SAMPLES - FINISHED #####"

echo "####################################################################################################################################################################################"

############################################################ Extract Samples ############################################################

for run in $runs
do
    pigz -d "$run"_1.fastq.gz -p 32
    echo "Final - "$run"_1"
    pigz -d "$run"_2.fastq.gz -p 32
    echo "Final - "$run"_2"
    echo "##### FINAL - $run #####"
done
echo "##### EXTRACT SAMPLES - FINISHED #####"

echo "####################################################################################################################################################################################"

