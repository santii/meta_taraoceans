#!/bin/bash 
#SBATCH --job-name=functional_annotation   #nome do job
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

cd $functional

### Functional Annotation
for run in $runs
do
    annotate idmapping "$alignment"/matches_"$run".m8 outputFunctional_"$run".txt NR2GO -d $db_func
    echo "##### FINAL - $run #####"
done
echo "##### Functional Annotation - FINISHED #####"

### AWK Reducing
for run in $runs
do
    awk -F "\t" '{print $2}' outputFunctional_"$run".txt > "$run"_temp.txt
    rm outputFunctional_"$run".txt
    sed 's/; /\n/g' "$run"_temp.txt > divided_"$run".txt
    rm "$run"_temp.txt
    awk -F "; " '{a[$1]++}END{for (i in a) print i"\t"a[i]}' divided_"$run".txt > counted_"$run".txt
    rm divided_"$run".txt
    echo "########## FINAL - "$run" ##########"
done
echo "##### AWK Reducing - FINISHED #####"

echo "##### Total Functional - FINISHED #####"

