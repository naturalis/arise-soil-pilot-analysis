library(vegan)
library(tidyverse)
library(dplyr)

set.seed(19760620)

loc1zt = read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location1OTUzTax2.csv", sep = ';', row.names = 1, header = TRUE)
loc1 = read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location1OTU.csv", sep = ',', row.names = 1)
loc1 <- t(loc1)

loc1zt <- as.data.frame(t(loc1zt))
loc1zt <- tibble::rownames_to_column(loc1zt, "enummers")

loc1zt_df <- loc1zt %>%
  pivot_wider(names_from = "N", values_from = "value", values_fill = 0) %>%
  as.data.frame()
### -> Error in `pivot_wider()`: ! Can't subset columns that don't exist.

loc1zt_df <- as.data.frame(loc1zt)
rownames(loc1zt_df) <- loc1zt_df$enummers
loc1zt_df <- loc1zt_df[,-1]

### step = enige outup is per stappen van 50
rarecurve_data <- rarecurve(loc1zt_df, step = 50)

### Pakt elk element van de list rarecurve_data, en bind het samen tot een dataframe
map_dfr(rarecurve_data, bind_rows) %>% 
  bind_cols(Group = rownames(loc1zt_df),.) %>%
  pivot_longer(-Group) %>%
  drop_na() %>%
  mutate(n_seq = as.numeric(str_replace(name, "N", ""))) %>%
  select(-name) %>%
  ggplot(aes(x=n_seq, y=value, group=Group)) +
  geom_line()

# drarefy: probability of seeing a specific taxa for sampling effort
loc1zt_df %>%
  bind_cols(Group = rownames(loc1zt_df),.) %>%
  group_by(Group) %>%
  summarize(n_seq = sum(value))


my_rarefy <- function(x, sample){
  
  x <- x[x>0]
  sum(1-exp(lchoose(sum(x) - x, sample) - lchoose(sum(x), sample)))
  
}