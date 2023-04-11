library(vegan)
library(tidyverse)
library(dplyr)

set.seed(19760620)

loc1zt = read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location1OTUzTax2.csv", sep = ';', row.names = 1, header = TRUE)
loc1 = read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location1OTU.csv", sep = ',', row.names = 1)
loc1 <- t(loc1)

loc1zt <- as.data.frame(t(loc1zt))
loc1zt <- tibble::rownames_to_column(loc1zt, "enummers")

loc1 <- read_tsv(loc1zt) %>%
  select(enummers, starts_with("OTU")) %>%
  pivot_longer(-Group) %>%
  group_by(Group)



my_rarefy <- function(x, sample){
  
  x <- x[x>0]
  sum(1-exp(lchoose(sum(x) - x, sample) - lchoose(sum(x), sample)))
  
}