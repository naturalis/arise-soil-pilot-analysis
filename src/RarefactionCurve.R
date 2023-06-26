library(vegan)
library(tidyverse)
library(dplyr)

set.seed(19760620)

loc1zt = read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location1OTUzTax2.csv", sep = ';', row.names = 1, header = TRUE)
loc3zt = read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location3OTUzTax.csv", sep = ';', row.names = 1, header = TRUE)


loc1 <- as.data.frame(t(loc1zt))
loc1 <- tibble::rownames_to_column(loc1, "enummers")

loc1_df <- as.data.frame(loc1)
rownames(loc1_df) <- loc1_df$enummers
loc1_df <- loc1_df[,-1]

### step = enige outup is per stappen van 50
rarecurve_data <- rarecurve(loc1_df, step = 50, label=FALSE)

### Pakt elk element van de list rarecurve_data, en bind het samen tot een dataframe
map_dfr(rarecurve_data, bind_rows) %>% 
  bind_cols(Group = rownames(loc1_df),.) %>%
  pivot_longer(-Group) %>%
  drop_na() %>%
  mutate(n_seq = as.numeric(str_replace(name, "N", ""))) %>%
  select(-name) %>%
  ggplot(aes(x=n_seq, y=value, group=Group)) +
  geom_line()
