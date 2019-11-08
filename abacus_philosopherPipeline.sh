#!/bin/bash
#SBATCH --account=cbio
#SBATCH --partition=ada
#SBATCH --nodes=1 --ntasks=40
#SBATCH --time=72:00:00
#SBATCH --job-name="abacus"
#SBATCH --mail-user=oknjav001@myuct.ac.za
#SBATCH --mail-type=END,FAIL

philosopherPath="/scratch/oknjav001/proteomics/philosopherd/philosopher"
ltbi="/scratch/oknjav001/philosopher_pipeline/abacus/ltbi"
prevtb="/scratch/oknjav001/philosopher_pipeline/abacus/prevtb"
rectb="/scratch/oknjav001/philosopher_pipeline/abacus/rectb"
#protxml="/scratch/oknjav001/proteomics/analysis_scripts/interact.prot.xml"

$philosopherPath abacus  $ltbi $prevtb $rectb

