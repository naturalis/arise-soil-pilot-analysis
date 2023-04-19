library(vegan)
library(tidyverse)
library(dplyr)

loc1zt = read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location1OTUzTax2.csv", sep = ';', row.names = 1, header = TRUE)

loc1zt <- as.data.frame(t(loc1zt))
loc1zt <- tibble::rownames_to_column(loc1zt, "enummers")

loc1zt_df <- as.data.frame(loc1zt)
rownames(loc1zt_df) <- loc1zt_df$enummers
loc1zt_df <- loc1zt_df[,-1]

### Werkt tot nu toe niet
loc1zt_df <- loc1zt %>%
  pivot_wider(names_from = row, values_from = "value")

loc1ztt <- loc1zt %>%
  bind_cols(Group = rownames(loc1zt_df),.) %>%
  select(Group, starts_with("OTU")) %>%
  pivot_longer(-Group) %>%
  mutate(total = sum(value)) %>%
  group_by(name) %>%
  mutate(total = sum(value)) %>%
  ungroup() %>%
  select(-total)

rand <- loc1ztt %>%
  uncount(value) %>%
  mutate(name = sample(name)) %>%
  count(Group, name, name="value")

loc1ztt %>%
  group_by(Group) %>%
  summarize(sobs = richness(value),
            shannon = shannon(value),
            simpson = simpson(value),
            invsimpson = 1/simpson,
            n = sum(value))

loc1ztt %>%
  group_by(Group) %>%
  summarize(sobs = richness(value),
            shannon = shannon(value),
            simpson = simpson(value),
            invsimpson = 1/simpson,
            n = sum(value)) %>%
  pivot_longer(cols = c(sobs, shannon, invsimpson, simpson),
               names_to = "metric") %>%
  ggplot(aes(x=n, y=value)) +
  geom_point() +
  geom_smooth() +
  facet_wrap(~metric, nrow = 4, scales = "free_y")

### Zelfde maar dan met rand (random sampling)
rand %>%
  group_by(Group) %>%
  summarize(sobs = richness(value),
            shannon = shannon(value),
            simpson = simpson(value),
            invsimpson = 1/simpson,
            n = sum(value)) %>%
  pivot_longer(cols = c(sobs, shannon, invsimpson, simpson),
               names_to = "metric") %>%
  ggplot(aes(x=n, y=value)) +
  geom_point() +
  geom_smooth() +
  facet_wrap(~metric, nrow = 4, scales = "free_y")

  

### 3 functions to calculate the richness, simpson and shannon

richness <- function(x){
  #r <- sum(x > 0)
  #return(r)
  sum(x>0)
}

shannon <- function(x){
  rabund <- x[x>0]/sum(x)
  -sum(rabund * log(rabund))
}

simpson <- function(x){
  n <- sum(x)
  sum(x * (x-1) / (n * (n-1)))
}


