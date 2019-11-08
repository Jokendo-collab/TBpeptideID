#!/bin/bash
#SBATCH --account=cbio
#SBATCH --partition=ada
#SBATCH --nodes=1 --ntasks=40
#SBATCH --time=72:00:00
#SBATCH --job-name="fragpipe"
#SBATCH --mail-user=oknjav001@myuct.ac.za
#SBATCH --mail-type=END,FAIL

set -xe

# Specify paths of tools and files. Change them accordingly.
dataDirPath="/scratch/oknjav001/bal_mzML_raw_files"
fastaPath="/scratch/oknjav001/bal_mzML_raw_files/2019-11-06-td-rev-UP000005640.fas"
msfraggerPath="/scratch/oknjav001/proteomics/MSFragger-2.1/MSFragger-2.1.jar"
fraggerParamsPath="/scratch/oknjav001/proteomics/MSFragger-2.1/open_fragger.params"
philosopherPath="/scratch/oknjav001/proteomics/philosopherd/philosopher"
crystalcPath="/scratch/oknjav001/proteomics/crystalc/CrystalC-1.0.5.jar"
crystalcParameterPath="/scratch/oknjav001/proteomics/crystalc/crystalc.params"
decoyPrefix="rev_"

# Run MSFragger. Change the number behind -Xmx according to your computer's memory size.
java -Xmx64G -jar $msfraggerPath $fraggerParamsPath $dataDirPath/*.mzML

# Move pepXML files to current directory.
mv $dataDirPath/*.pepXML ./

# Move tsv files to current directory.
mv $dataDirPath/*.tsv ./ # Comment this line if localize_delta_mass = 0 in your fragger.params file.

# Run Crystal-C If it is an open search, run Crystal-C. Otherwise, don't run it by commenting the following for-loop
for myFile in ./*.pepXML
do
	java -Xmx64G -cp $crystalcPath Main $crystalcParameterPath $myFile
done

# Run PeptideProphet, ProteinProphet, and FDR filtering inside Philosopher
$philosopherPath workspace --clean
$philosopherPath workspace --init
$philosopherPath database --annotate $fastaPath --prefix $decoyPrefix

# Pick one from the following three commands and comment rest of two..
##$philosopherPath peptideprophet --nonparam --expectscore --decoyprobs --ppm --accmass --decoy $decoyPrefix --database $fastaPath ./*.pepXML # For closed search
$philosopherPath peptideprophet --nonparam --expectscore --decoyprobs --masswidth 1000.0 --clevel -2 --decoy $decoyPrefix --combine --database $fastaPath ./*.pepXML --freequant # For open search
##$philosopherPath peptideprophet --nonparam --expectscore --decoyprobs --ppm --accmass --nontt --decoy $decoyPrefix --database $fastaPath ./*.pepXML # For non-specific closed search

$philosopherPath proteinprophet --maxppmdiff 2000000 ./*.pep.xml

# Pick one from the following two commands and comment the other one.
##$philosopherPath filter --sequential --razor --mapmods --tag $decoyPrefix --pepxml ./ --protxml ./interact.prot.xml # closed or non-specific closed search
$philosopherPath filter --sequential --razor --mapmods --tag $decoyPrefix --pepxml ./interact.pep.xml --protxml ./interact.prot.xml # open search

$philosopherPath report
$philosopherPath workspace --clean
