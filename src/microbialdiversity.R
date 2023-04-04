library(ggplot2)
library(ape)
library(plyr)
library(vegan)
library(RColorBrewer)
library(reshape2)
library(scales)
library(data.table)
library(microbiome)
library(dplyr)
library(phyloseq)
library(DT)
library(microbiomeutilities)

BiocManager::install("biomformat")

loc1 <- read_csv2phyloseq(otu.file = "~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location1OTU.csv", sep = ",")
blub = read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location1OTU.csv")
loc1 <- read_csv2phyloseq(
  otu.file = "~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location1OTU.csv",
  taxonomy.file = NULL,
  metadata.file = NULL,
  sep = ","
)

loc1OTU_data <- read_csv2phyloseq(otu.file = blub, sep = ",")
