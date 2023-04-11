if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(version = "3.16")

BiocManager::install("metagenomeSeq", force = TRUE)
BiocManager::install("Biobase", force = TRUE)
BiocManager::install("AnnotatedDataFrame")
library(metagenomeSeq)
library(tidyverse)

#asvtable <- read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/ASVtab_raw.csv") %>%
#  select()
#location1 <- c()
loc1OTU_data <- read.delim("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location1OTU.csv", sep = ",")
loc3_data <- read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location3OTU.csv", header = TRUE)
loc1_asv <- read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location1.csv", header = TRUE)
loc3_asv <- read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location3.csv", header = TRUE)

pie(table(loc3_asv$Phylum))
unique(loc1_asv$Phylum)

OTUloc1data <- AnnotatedDataFrame(loc1OTU_data)
row.names(OTUloc1data) <- loc1OTU_data$OTUnr
OTUloc1data

