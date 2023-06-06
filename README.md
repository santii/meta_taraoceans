# meta_taraocean

This repository is the result of a master's project in Bioinformatics, focusing on ocean metagenomics. For this analysis, data obtained from the [Tara Oceans Expedition](http://ocean-microbiome.embl.de/companion.html) and the [MEDUSA](https://github.com/dalmolingroup/MEDUSA) open source pipeline were used.

To reproduce the results, it is important to correctly follow the steps present in this README or even those present in each directory of this repository.

## Preparation of the working environment
1. go to data/pipeline_workflow/00-default
'''
cd ~/meta_taraoceans/data/pipeline_workflow/00-default
'''
2. adjust the paths of variables present in 00-var.sh to your local computer
'''
nano 00-var.sh
'''
3. follow the steps present in 00-environment.sh
 
## Pipeline execution
1. activate the environment
'''
conda activate medusaPipeline
'''
2. execute, in order, each step of the pipeline. Note: only start the next one after finishing the previous one.
'''
nohup 01-raw_data.sh &
nohup 02-preprocessing.sh &
nohup 03-alignment.sh &
nohup 04-taxonomic_classification.sh &
nohup 05-functional_annotation.sh &
'''
## Results
- Taxonomic Classification
'''
cd meta_taraoceans/data/results/code/taxonomic
R taxonomic.R
'''
- Biodiversity
'''
cd meta_taraoceans/data/results/code/biodiversity
R biodiversity.R
'''
- Functional Annotation
'''
cd meta_taraoceans/data/results/code/functional
R functional.R
'''

For more information about the MEDUSA pipeline, check:
Morais, D.A.A.; Cavalcante, J.V.F.; Monteiro, S.S.; Pasquali, M.A.B.; Dalmolin, R.J.S. MEDUSA: A Pipeline for Sensitive 480
Taxonomic Classification and Flexible Functional Annotation of Metagenomic Shotgun Sequences, 2022. https://doi.org/https: 481
//doi.org/10.3389/fgene.2022.814437.
