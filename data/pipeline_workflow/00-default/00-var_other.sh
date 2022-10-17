#!/bin/bash 

### Declaring variables

local_address="/scratch/global/bcfsantiago/master_degree/taraocean/"
protocol="/scratch/global/bcfsantiago/master_degree/taraocean/newProtocol/Protocol/"

data="/scratch/global/bcfsantiago/master_degree/taraocean/newProtocol/Protocol/data"
raw="/scratch/global/bcfsantiago/master_degree/taraocean/newProtocol/Protocol/data/raw"
trimmed="/scratch/global/bcfsantiago/master_degree/taraocean/newProtocol/Protocol/data/trimmed"
removal="/scratch/global/bcfsantiago/master_degree/taraocean/newProtocol/Protocol/data/removal"    
reference="/scratch/global/bcfsantiago/master_degree/taraocean/newProtocol/Protocol/data/removal/reference"
index_remo="/scratch/global/bcfsantiago/master_degree/taraocean/newProtocol/Protocol/data/removal/index/host"
assembled="/scratch/global/bcfsantiago/master_degree/taraocean/newProtocol/Protocol/data/assembled"
collapsed="/scratch/global/bcfsantiago/master_degree/taraocean/newProtocol/Protocol/data/collapsed"

alignment="/scratch/global/bcfsantiago/master_degree/taraocean/newProtocol/Protocol/alignment"
db_alig="/scratch/global/bcfsantiago/master_degree/taraocean/newProtocol/Protocol/alignment/db"
index_alig="/scratch/global/bcfsantiago/master_degree/taraocean/newProtocol/Protocol/alignment/index"

taxonomic="/scratch/global/bcfsantiago/master_degree/taraocean/newProtocol/Protocol/taxonomic"
kaiju="/scratch/global/bcfsantiago/master_degree/dbs/kaiju"
reduced="/scratch/global/bcfsantiago/master_degree/taraocean/newProtocol/Protocol/taxonomic/reduced"

functional="/scratch/global/bcfsantiago/master_degree/taraocean/newProtocol/Protocol/functional"
db_func="/scratch/global/bcfsantiago/master_degree/taraocean/newProtocol/Protocol/functional/db"

# index_remo_diego="/scratch/global/dadamorais/Protocol/data/removal/index/hs102"
# index_alig_diego="/scratch/global/dadamorais/Protocol/alignment/index/nr160121"

url="ftp://ftp.sra.ebi.ac.uk/vol1/fastq/"
slash="/"
one="_1.fastq.gz"
two="_2.fastq.gz"

runs="ERR594324
ERR598972
ERR599023
ERR599025
ERR594385
ERR599021
ERR599164
ERR598970
ERR599088
ERR599150
ERR594392
ERR594291
ERR598990
ERR599018
ERR599110
ERR594382
ERR594414
ERR598960
ERR599034
ERR594320
ERR598979
ERR599146
ERR594359
ERR594361
ERR599040
ERR599148
ERR594321
ERR594298
ERR594355
ERR599000
ERR599154
ERR594333
ERR599010
ERR599126
ERR594310
ERR594286
ERR594354
ERR599046
ERR599101
ERR594336
ERR594303
ERR599124
ERR599159
ERR594289
ERR599006
ERR599022
ERR594340
ERR594332
ERR594411
ERR599042
ERR599079
ERR599071
ERR599085
ERR599093
ERR599120
ERR598961
ERR599086
ERR599077"

