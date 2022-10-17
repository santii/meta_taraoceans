#!/bin/bash 
#SBATCH --job-name=taxonomic_classification   #nome do job
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

cd "$taxonomic"

### Taxonomic Classification
for run in $runs
do
    kaiju -t "$db_kaiju"/nodes.dmp -f "$db_kaiju"/kaiju_db_nr.fmi -i "$collapsed"/"$run".fasta -o "$taxonomic"/"$run"_kaiju.out -z 64
    kaiju-addTaxonNames -t "$db_kaiju"/nodes.dmp -n "$db_kaiju"/names.dmp -r superkingdom,phylum,class,order,family,genus,species -i "$taxonomic"/"$run"_kaiju.out -o "$taxonomic"/"$run"_kaiju.names.out
    rm "$taxonomic"/"$run"_kaiju.out
    echo "########## FINAL - "$run" ##########"
done
echo "##### Taxonomic Classification - FINISHED #####"


### AWK Reducing
for run in $runs
do
    awk -F "\t" '{if($1 == "C") {print}}' "$taxonomic"/"$run"_kaiju.names.out > "$taxonomic"/"$run"_kaiju.names_filtrado.txt
    rm "$taxonomic"/"$run"_kaiju.names.out
    awk -F "\t" '{print $4}' "$taxonomic"/"$run"_kaiju.names_filtrado.txt > "$reduced"/"$run"_temp.txt
    awk -F "; " '{a[$1]++}END{for (i in a) print i"\t"a[i]}' "$reduced"/"$run"_temp.txt > "$reduced"/kingdom_"$run"_names.txt
    awk -F "; " '{a[$2]++}END{for (i in a) print i"\t"a[i]}' "$reduced"/"$run"_temp.txt > "$reduced"/phylum_"$run"_names.txt
    awk -F "; " '{a[$3]++}END{for (i in a) print i"\t"a[i]}' "$reduced"/"$run"_temp.txt > "$reduced"/class_"$run"_names.txt
    awk -F "; " '{a[$4]++}END{for (i in a) print i"\t"a[i]}' "$reduced"/"$run"_temp.txt > "$reduced"/order_"$run"_names.txt
    awk -F "; " '{a[$5]++}END{for (i in a) print i"\t"a[i]}' "$reduced"/"$run"_temp.txt > "$reduced"/family_"$run"_names.txt
    awk -F "; " '{a[$6]++}END{for (i in a) print i"\t"a[i]}' "$reduced"/"$run"_temp.txt > "$reduced"/genus_"$run"_names.txt
    awk -F "; " '{a[$7]++}END{for (i in a) print i"\t"a[i]}' "$reduced"/"$run"_temp.txt > "$reduced"/species_"$run"_names.txt
    rm "$reduced"/"$run"_temp.txt
    rm "$taxonomic"/"$run"_kaiju.names_filtrado.txt
    echo "########## FINAL - "$run" ##########"
done
echo "##### AWK Reducing - FINISHED #####"

echo "##### Total Classification - FINISHED #####"

