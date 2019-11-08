#!/bin/sh
#SBATCH --account=cbio
#SBATCH --partition=ada
#SBATCH --nodes=1 --ntasks=40
#SBATCH --time=40:00:00
#SBATCH --job-name="msfragger_closedSearch"
#SBATCH --mail-user=oknjav001@myuct.ac.za
#SBATCH --mail-type=END,FAIL

fragger=/scratch/oknjav001/proteomics/MSFragger-2.1/MSFragger-2.1.jar ##path to the jar file

params=/scratch/oknjav001/proteomics/MSFragger-2.1/open_fragger.params ## path to the parameter file

raw_file=/scratch/oknjav001/bal_mzML_raw_files/*.mzML ## path to the raw files


java -Xmx32g -jar ${fragger} ${params} ${raw_file}
