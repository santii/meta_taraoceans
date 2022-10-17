#!/bin/bash 
#SBATCH --job-name=taxonomic_analysis 	#nome do job
#SBATCH --time=0-5:59				#tempo limite de execucao

#SBATCH --nodes=1 				#número de nós
#SBATCH --ntasks=4 				#número total de tarefas
#SBATCH --ntasks-per-node=2 			#número de tarefas por no
#SBATCH --cpus-per-task=32			#numero de nucleos por tarefas
#SBATCH --mem=128000				#quantidade total de memoria
#SBATCH --mem-per-cpu=8000			#quantidade de memoria por nucleo
#SBATCH --qos=qos2				#tipo de multiplos jobs
#SBATCH --exclusive				#no exclusivo
 
#SBATCH --mail-user=bianca.santiago72@gmail.com
#SBATCH --mail-type=ALL

srun prog1 #programa a ser executado. #srun: executa jobs em paralelo

./prog1
