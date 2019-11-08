#!/bin/sh
#SBATCH --account=cbio
#SBATCH --partition=ada
#SBATCH --nodes=1 --ntasks=40
#SBATCH --time=40:00:00
#SBATCH --job-name="msfraggerTut"
#SBATCH --mail-user=oknjav001@myuct.ac.za
#SBATCH --mail-type=END,FAIL

#set the global environment variables
fragger=/scratch/oknjav001/proteomics/MSFragger-2.1/MSFragger-2.1.jar
params=/scratch/oknjav001/bal_mzML_raw_files/params/open_fragger.params
raw_file=/scratch/oknjav001/bal_mzML_raw_files/*.mzML
philosopher=/scratch/oknjav001/proteomics/philosopherd/philosopher

#Move to the directory containing the raw data files
cd /scratch/oknjav001/bal_mzML_raw_files

#Prepare the workspace
${philosopher} workspace --init

#Fetching a human protein database

${philosopher} database --id UP000005640 --reviewed --contam


java -Xmx32g -jar ${fragger} ${params} $raw_file/*.mzML

#Validating the peptide identifications

${philosopher} peptideprophet --accmass --clevel -2 --combine --database 2019-11-06-td-rev-UP000005640.fas --decoy rev_ --decoyprobs --expectscore --nonparam --masswidth 1000.0 *.pepXML

#Inferring proteins from peptide matches

${philosopher} proteinprophet --maxppmdiff 100000 interact.pep.xml

#Calculating false discovery rates (FDR)
${philosopher} filter --pepxml interact.pep.xml --protxml interact.prot.xml --sequential --razor --mapmods --models

#Reporting

${philosopher} report

${philosopher} workspace --clean


























