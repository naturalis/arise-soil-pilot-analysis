library(vegan)
library(tidyverse)

#asvtable <- read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/ASVtab_raw.csv") %>%
#  select()
#location1 <- c()
asvtable <- read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/ASVtab_raw.csv")
data("BCI")

loc1 <- asvtable["e4057163188"]
