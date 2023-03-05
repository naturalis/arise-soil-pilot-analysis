if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("metagenomeSeq")
library(metagenomeSeq)

#asvtable <- read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/ASVtab_raw.csv") %>%
#  select()
#location1 <- c()
loc1_data <- read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location1.csv", header = TRUE)
loc3_data <- read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location3.csv", header = TRUE)

head(loc1_data)[,1:6]

richness <- estimate_richness(loc1_data)
head(richness)