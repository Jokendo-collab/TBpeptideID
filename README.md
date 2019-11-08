# Motivation
Integration of heterogeneous and voluminous data from proteomics, transcriptomics, Immunological and clinical research constitutes not only a fundamental problem but a real hurdle in the extraction of valuable information to the surface from these omics data sets. The exponential increase of the novel omics technologies such as LC-MS/MS and the generation of high-resolution data from the large consortia projects generates heterogenous and big data sets. 

### This pipeline is designed to do the following:
* Peptide Spectrum Matching with ![MSfragger](http://fragpipe.nesvilab.org/).
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


