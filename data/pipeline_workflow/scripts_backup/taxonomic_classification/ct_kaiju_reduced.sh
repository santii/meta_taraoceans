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

local_address="/storages/tmp4/santi/master_degree/taraocean/"
protocol="/storages/tmp4/santi/master_degree/taraocean/Protocol"
alignment="/storages/tmp4/santi/master_degree/taraocean/Protocol/alignment"
data="/storages/tmp4/santi/master_degree/taraocean/Protocol/data"
functional="/storages/tmp4/santi/master_degree/taraocean/Protocol/functional"
taxonomic="/storages/tmp4/santi/master_degree/taraocean/Protocol/taxonomic"
db="/storages/tmp4/santi/master_degree/taraocean/Protocol/alignment/db"
index_alig="/storages/tmp4/santi/master_degree/taraocean/Protocol/alignment/index"
assembled="/storages/tmp4/santi/master_degree/taraocean/Protocol/data/assembled"
collapsed="/storages/tmp4/santi/master_degree/taraocean/Protocol/data/collapsed"
removal="/storages/tmp4/santi/master_degree/taraocean/Protocol/data/removal"    
trimmed="/storages/tmp4/santi/master_degree/taraocean/Protocol/data/trimmed"
index_remo="/storages/tmp4/santi/master_degree/taraocean/Protocol/data/removal/index/host"
reference="/storages/tmp4/santi/master_degree/taraocean/Protocol/data/removal/reference"
sample_test="/storages/tmp4/santi/master_degree/taraocean/Protocol/data/sample_test"
#index_remo_diego="/scratch/global/dadamorais/Protocol/data/removal/index/hs102"
#index_alig_diego="/scratch/global/dadamorais/Protocol/alignment/index/nr160121"

index_general_dbs="/storages/tmp4/santi/master_degree/dbs/bastadb"
kaiju="/storages/tmp4/santi/master_degree/dbs/kaiju"
reduced="/storages/tmp4/santi/master_degree/taraocean/Protocol/taxonomic/reduced"

######################################################################################################################################################################################################

### Divisão Taxonômica

cd "$taxonomic"

#Modelo: kaiju -t kaiju/nodes.dmp -f kaiju/kaiju_db_nr.fmi -i benchmark/sim1.fastq -o benchmark/kaiju.out -z 64
#Modelo: kaiju-addTaxonNames -t kaiju/nodes.dmp -n kaiju/names.dmp -r superkingdom,phylum,class,order,family,genus,species -i benchmark/kaiju.out -o benchmark/kaiju.names.out

for run in $runs
do
    kaiju -t "$kaiju"/nodes.dmp -f "$kaiju"/kaiju_db_nr.fmi -i "$collapsed"/"$run".fasta -o "$taxonomic"/"$run"_kaiju.out -z 64
    kaiju-addTaxonNames -t "$kaiju"/nodes.dmp -n "$kaiju"/names.dmp -r superkingdom,phylum,class,order,family,genus,species -i "$taxonomic"/"$run"_kaiju.out -o "$taxonomic"/"$run"_kaiju.names.out
    echo "########## FINAL da "$run" ##########"
done

echo "##### Divisão Taxonômica - FINALIZADO #####"


### Redução com AWK

for run in $runs
do
    awk -F "\t" '{if($1 == "C") {print}}' "$taxonomic"/"$run"_kaiju.names.out > "$taxonomic"/"$run"_kaiju.names_filtrado.txt
    #rm "$taxonomic"/"$run"_kaiju.names.out
    #rm "$taxonomic"/"$run"_kaiju.out
    awk -F "\t" '{print $4}' "$taxonomic"/"$run"_kaiju.names_filtrado.txt > "$reduced"/"$run"_temp.txt
    awk -F "; " '{a[$1]++}END{for (i in a) print i"\t"a[i]}' "$reduced"/"$run"_temp.txt > "$reduced$slash"kingdom_"$run"_names.txt
    awk -F "; " '{a[$2]++}END{for (i in a) print i"\t"a[i]}' "$reduced"/"$run"_temp.txt > "$reduced$slash"phylum_"$run"_names.txt
    awk -F "; " '{a[$3]++}END{for (i in a) print i"\t"a[i]}' "$reduced"/"$run"_temp.txt > "$reduced$slash"class_"$run"_names.txt
    awk -F "; " '{a[$4]++}END{for (i in a) print i"\t"a[i]}' "$reduced"/"$run"_temp.txt > "$reduced$slash"order_"$run"_names.txt
    awk -F "; " '{a[$5]++}END{for (i in a) print i"\t"a[i]}' "$reduced"/"$run"_temp.txt > "$reduced$slash"family_"$run"_names.txt
    awk -F "; " '{a[$6]++}END{for (i in a) print i"\t"a[i]}' "$reduced"/"$run"_temp.txt > "$reduced$slash"genus_"$run"_names.txt
    awk -F "; " '{a[$7]++}END{for (i in a) print i"\t"a[i]}' "$reduced"/"$run"_temp.txt > "$reduced$slash"species_"$run"_names.txt
    rm "$reduced"/"$run"_temp.txt
    #rm "$taxonomic"/"$run"_kaiju.names_filtrado.txt
    echo "########## FINAL da "$run" ##########"
done

echo "##### Redução Taxonômica - FINALIZADO #####"


echo "##### CLASSIFICAÇÃO TOTAL - FINALIZADO #####"

