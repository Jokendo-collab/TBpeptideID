#!/bin/bash
#SBATCH --account=cbio
#SBATCH --partition=ada
#SBATCH --nodes=1 --ntasks=40
#SBATCH --time=72:00:00
#SBATCH --job-name="philosopher_pipeline"
#SBATCH --mail-user=oknjav001@myuct.ac.za
#SBATCH --mail-type=END,FAIL

#Create the global paths for the philosopher and the config file respectively
philosopherPath="/scratch/oknjav001/proteomics/philosopherd/philosopher"
config="/scratch/oknjav001/proteomics/philosopherd/philosopher.yml"

#change to the directory containing the data from different experimental groups
cd /scratch/oknjav001/philosopher_pipeline

#create the workspace
$philosopherPath workspace --init

#run the pipeline on the data
$philosopherPath pipeline --config $config ltbi prevtb rectb

#Remove the created workspace after the analysis is done
$philosopherPath workspace --clean
