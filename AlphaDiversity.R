library(microbiome)
library(ggpubr)
library(knitr)
library(dplyr)

loc1 <- read.delim("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location1OTU.csv", sep = ",")
#ps1 <- prune_taxa(taxa_sums(pseq) > 0, pseq)

tab <- microbiome::alpha(loc1, index = "OTUnr, Phylum")
kable(head(tab))

data(dietswap)
pseq <- dietswap