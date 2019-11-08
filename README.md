# Motivation
Integration of heterogeneous and voluminous data from proteomics, transcriptomics, Immunological and clinical research constitutes not only a fundamental problem but a real hurdle in the extraction of valuable information to the surface from these omics data sets. The exponential increase of the novel omics technologies such as LC-MS/MS and the generation of high-resolution data from the large consortia projects generates heterogenous and big data sets. 

### This pipeline is designed to do the following:
* Peptide Spectrum Matching with [MSfragger](http://fragpipe.nesvilab.org/).
* Peptide assignment validation with PeptideProphet.
* Multi-level integrative analysis with iProphet.
* PTM site localization with PTMProphet.
* Protein inference with ProteinProphet.
* Open Search data validation.
* FDR filtering with custom algorithms.
* Two-dimensional filtering for simultaneous control of PSM and Protein FDR levels.
* Sequential FDR estimation for large data sets using filtered PSM and proteins lists.
* PickedFDR for scalable estimations.
* Razor peptide assignment for better quantification and interpretation.
* Label-free quantification via Spectral counting and MS1 Quantification.
* Labeling-based quantification using TMT isobaric tags.
* Clustering analysis for proteomics results.
* Multi-level detailed reports including peptides, ions and proteins.

## Running fragpipe linux workflow
#!/bin/bash
#SBATCH --account=cbio
#SBATCH --partition=ada
#SBATCH --nodes=1 --ntasks=40
#SBATCH --time=72:00:00
#SBATCH --job-name="fragpipe"
#SBATCH --mail-user=oknjav001@myuct.ac.za
#SBATCH --mail-type=END,FAIL

set -xe

### Specify paths of tools and files. Change them accordingly.
```
dataDirPath="/scratch/oknjav001/bal_mzML_raw_files"
fastaPath="/scratch/oknjav001/bal_mzML_raw_files/2019-11-06-td-rev-UP000005640.fas"
msfraggerPath="/scratch/oknjav001/proteomics/MSFragger-2.1/MSFragger-2.1.jar"
fraggerParamsPath="/scratch/oknjav001/proteomics/MSFragger-2.1/open_fragger.params"
philosopherPath="/scratch/oknjav001/proteomics/philosopherd/philosopher"
crystalcPath="/scratch/oknjav001/proteomics/crystalc/CrystalC-1.0.5.jar"
crystalcParameterPath="/scratch/oknjav001/proteomics/crystalc/crystalc.params"
decoyPrefix="rev_"
```
### Run MSFragger. Change the number behind -Xmx according to your computer's memory size.
`java -Xmx64G -jar $msfraggerPath $fraggerParamsPath $dataDirPath/*.mzML`

### Move pepXML files to current directory.
`mv $dataDirPath/*.pepXML ./`

### Move tsv files to current directory.
`mv $dataDirPath/*.tsv ./ # Comment this line if localize_delta_mass = 0 in your fragger.params file.`

### Run Crystal-C If it is an open search, run Crystal-C. Otherwise, don't run it by commenting the following for-loop
```
for myFile in ./*.pepXML
do
        java -Xmx64G -cp $crystalcPath Main $crystalcParameterPath $myFile
done
```
### Run PeptideProphet, ProteinProphet, and FDR filtering inside Philosopher
```
$philosopherPath workspace --clean
$philosopherPath workspace --init
$philosopherPath database --annotate $fastaPath --prefix $decoyPrefix
```
### Pick one from the following three commands and comment rest of two.
```
$philosopherPath peptideprophet --nonparam --expectscore --decoyprobs --masswidth 1000.0 --clevel -2 --decoy $decoyPrefix --combine --database $fastaPath ./*.pepXML --freequant # For open search
$philosopherPath proteinprophet --maxppmdiff 2000000 ./*.pep.xml
```

### Pick one from the following two commands and comment the other one.
`$philosopherPath filter --sequential --razor --mapmods --tag $decoyPrefix --pepxml ./interact.pep.xml --protxml ./interact.prot.xml # open search`

### Create the report
```
$philosopherPath report
$philosopherPath workspace --clean
```


