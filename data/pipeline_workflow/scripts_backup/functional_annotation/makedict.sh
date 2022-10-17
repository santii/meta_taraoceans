rule all:
    input: "NR2GO.ldb"

rule downloadUniprotMapping:
    output: "idmapping_selected.tab"
    threads: workflow.cores
    shell: "set +eu \
        && . $(conda info --base)/etc/profile.d/conda.sh && conda activate medusaPipeline \
        && wget ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/idmapping/idmapping_selected.tab.gz \
        && pigz -d {output} -p {threads}"

rule createDictionaries:
    input: "idmapping_selected.tab"
    output:
        directory("NR2GO.ldb"),
    threads: workflow.cores
    shell: "set +eu \
        && . $(conda info --base)/etc/profile.d/conda.sh && conda activate medusaPipeline \
        && awk -F \"\t\" '{{if(($7!=\"\") && ($18!=\"\")){{print $18\"\t\"$7}}}}' {input} > genbank2GO.txt \
        && awk -F \"\t\" '{{if(($4!=\"\") && ($7!=\"\")){{print $4\"\t\"$7}}}}' {input} > refseq2GO.txt \
        && Rscript createDictionary.R NR2GO.txt genbank2GO.txt refseq2GO.txt {threads} \
        && annotate createdb NR2GO.txt NR2GO 0 1 -d . \
        && rm genbank2GO.txt refseq2GO.txt {input}"
