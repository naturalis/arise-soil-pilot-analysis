library(vegan)

loc1 = read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location1OTUzTax2.csv", sep = ';')

head(loc1)

data(BCI)
head(BCI)

S <- specnumber(loc1)
(raremax <- min(rowSums(loc1$Phylum)))
Srare <- rarefy(loc1, raremax)