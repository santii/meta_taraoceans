
######################################################################################################################################################################################################

### Declarando variaveis

runs="ERR599026
ERR594324
ERR594321
ERR594336
ERR598965
ERR598961
ERR599042"

local="/home/biancasantiago/Documentos/kaiju_data"

######################################################################################################################################################################################################

### Divisão Taxonômica

cd $local

#Modelo: kaiju -t kaiju/nodes.dmp -f kaiju/kaiju_db_nr.fmi -i benchmark/sim1.fastq -o benchmark/kaiju.out -z 64
#Modelo: kaiju-addTaxonNames -t kaiju/nodes.dmp -n kaiju/names.dmp -r superkingdom,phylum,class,order,family,genus,species -i benchmark/kaiju.out -o benchmark/kaiju.names.out

for run in $runs
do
    #awk -F "\t" '{if($1 == "C") {print}}' "$run"_kaiju.names.out > "$run"_kaiju.names_filtrado.txt
    #rm "$run"_kaiju.names.out
    #rm "$run"_kaiju.out
    awk -F "\t" '{print $4}' "$run"_kaiju.names_filtrado.txt > "$run"_temp.txt
    awk -F "; " '{a[$1]++}END{for (i in a) print i"\t"a[i]}' "$run"_temp.txt > kingdom_"$run"_names.txt
    awk -F "; " '{a[$2]++}END{for (i in a) print i"\t"a[i]}' "$run"_temp.txt > phylum_"$run"_names.txt
    awk -F "; " '{a[$3]++}END{for (i in a) print i"\t"a[i]}' "$run"_temp.txt > class_"$run"_names.txt
    awk -F "; " '{a[$4]++}END{for (i in a) print i"\t"a[i]}' "$run"_temp.txt > order_"$run"_names.txt
    awk -F "; " '{a[$5]++}END{for (i in a) print i"\t"a[i]}' "$run"_temp.txt > family_"$run"_names.txt
    awk -F "; " '{a[$6]++}END{for (i in a) print i"\t"a[i]}' "$run"_temp.txt > genus_"$run"_names.txt
    awk -F "; " '{a[$7]++}END{for (i in a) print i"\t"a[i]}' "$run"_temp.txt > species_"$run"_names.txt
    rm "$run"_temp.txt
    rm "$run"_kaiju.names_filtrado.txt
    echo "########## FINAL da "$run" ##########"
done

echo "##### Divisão Taxonômica - FINALIZADO #####"

