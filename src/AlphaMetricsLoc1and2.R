library(vegan)
library(tidyverse)
library(dplyr)

loc1zt = read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location1OTUzTax2.csv", sep = ';', row.names = 1, header = TRUE)
loc3zt = read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location3OTUzTax.csv", sep = ';', row.names = 1, header = TRUE)

loc3zt <- as.data.frame(t(loc3zt))
loc3zt <- tibble::rownames_to_column(loc3zt, "enummers")

loc3zt_df <- as.data.frame(loc3zt)
rownames(loc3zt_df) <- loc3zt_df$enummers
loc3zt_df <- loc3zt_df[,-1]

loc3ztt <- loc3zt %>%
  bind_cols(Group = rownames(loc3zt_df),.) %>%
  select(Group, starts_with("OTU")) %>%
  pivot_longer(-Group) %>%
  mutate(total = sum(value)) %>%
  group_by(name) %>%
  mutate(total = sum(value)) %>%
  ungroup() %>%
  select(-total)

rand <- loc3ztt %>%
  uncount(value) %>%
  mutate(name = sample(name)) %>%
  count(Group, name, name="value")

metric_statistics <- loc3ztt %>%
  group_by(Group) %>%
  summarize(sobs = richness(value),
            shannon = shannon(value),
            simpson = simpson(value),
            invsimpson = 1/simpson,
            n = sum(value))

loc3ztt %>%
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

### Same plot generater but then for rand (random sampling)
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


### Same plot generater but then with vegan packages instead of our own (random sampling)
rand %>%
  group_by(Group) %>%
  summarize(sobs = specnumber(value),
            shannon = diversity(value, index = "shannon"),
            simpson = diversity(value, index="simpson"),
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


