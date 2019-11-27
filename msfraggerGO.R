
setwd("C:/Users/Javan_Okendo/Desktop/proteomcs/gomsfragger")

# analysis url: https://bioshare.bioinformatics.ucdavis.edu/bioshare/download/tfxp6w02segq7c6/msfragger_cluser_profiler.nb.html
# load Libraries (install if necessary) 

packages = c("BiocManager","tidyverse","clusterProfiler","org.Hs.eg.db")

package.check <- lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dependencies = TRUE)
    library(x, character.only = TRUE)
  }
})

# BiocManager::install("clusterProfiler") # may need to uncomment this line  if this does not install because of bioconductor install weirdness 

# BiocManager::install("org.Hs.eg.db") # may need to uncomment this line if this does not install because of bioconductor install weirdness 

#verify they are loaded
search()

# load  msFragger data 
# this is a 100 ng hela run on teh timstofPRO
# Change this to the combined protein file if it's a multiexperiment

data <- read_tsv("combined_protein.tsv")

library(org.Hs.eg.db) # this is for human. load a different library from here for a different speccies http://bioconductor.org/packages/release/BiocViews.html#___OrgDb

gene <- data$`Gene Names` # extract Gene's from MSFragger

# this translates the Gene from MSfragger to something enrichgo can read

gene.df <- bitr(gene, fromType = "SYMBOL", 
                toType = "ENTREZID",
                OrgDb = org.Hs.eg.db)


# Make a geneList for some future functions

geneList <- gene.df$ENTREZID
names(geneList) <- as.character(gene.df$SYMBOL)
geneList <- sort(geneList, decreasing = TRUE)


# gene enrichment analysis cnplots are commented out as they look crazy with a large number of proteins
## BP
ego_BP <- enrichGO(gene = gene.df$ENTREZID,
                   OrgDb = org.Hs.eg.db,
                   ont = "BP",
                   pAdjustMethod = "BH",
                   readable = TRUE,
                   pvalueCutoff  = 0.01,
                   qvalueCutoff  = 0.05)

ego_BP_df <-as.data.frame(ego_BP) 

dotplot(ego_BP, showCategory=15)


##cnetplot(ego_BP,categorySize="pvalue") The output looks crazy with large number of proteins
# CC

ego_CC <- enrichGO(gene = gene.df$ENTREZID,
                   OrgDb = org.Hs.eg.db,
                   ont = "CC",
                   pAdjustMethod = "BH",
                   readable = TRUE,
                   pvalueCutoff  = 0.01,
                   qvalueCutoff  = 0.05)

ego_CC_df <-as.data.frame(ego_CC)

dotplot(ego_CC, showCategory=15)

## MF
ego_MF <- enrichGO(gene = gene.df$ENTREZID,
                   OrgDb  = org.Hs.eg.db,
                   ont = "MF",
                   pAdjustMethod = "BH",
                   readable = TRUE,
                   pvalueCutoff  = 0.01,
                   qvalueCutoff  = 0.05)

ego_MF_df <-as.data.frame(ego_MF)

dotplot(ego_MF, showCategory=15)

barplot(ego_MF, showCategory=15)

#Biological Process (BP):  
#Cellular Component (CC):
#Molecular Function (MF): 

# write Go data to csv files

write_csv(ego_BP_df,"go_biological.process.tbhart.csv")
write_csv(ego_CC_df,"go_cellular_component.tbhart.csv")
write_csv(ego_MF_df,"go_molecular_function.tbhart.csv")


#Let's look at KEGG over-representation
human <- search_kegg_organism('Homo sapiens', by='scientific_name') # find keg number for human

kk <- enrichKEGG(gene = gene.df$ENTREZID,
                 organism = 'hsa',
                 pvalueCutoff = 0.05)
head(kk, n=10)

View(kk)

# Enrichment map organizes enriched terms into a network with edges connecting overlapping gene sets. 
#In this way, mutually overlapping gene sets are tend to cluster together, making it easy to identify 
#functional module.

emapplot(ego_BP,pie_scale=1.5,layout="kk")

#WikiPathways

##BiocManager::install("rWikiPathways")

library(rWikiPathways)
downloadPathwayArchive(organism="Homo sapiens",format="gmt") #download human wikipathway file

wp2gene <- read.gmt("wikipathways-20191110-gmt-Homo_sapiens.gmt") #read downloaded file

wp2gene <- wp2gene %>% tidyr::separate(ont, c("name","version","wpid","org"), "%")
wpid2gene <- wp2gene %>% dplyr::select(wpid, gene) #TERM2GENE
wpid2name <- wp2gene %>% dplyr::select(wpid, name) #TERM2NAME

ewp <- enricher(geneList, TERM2GENE = wpid2gene, TERM2NAME = wpid2name)

head(ewp)




























































