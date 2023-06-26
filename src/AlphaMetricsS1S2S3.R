library(vegan)
library(tidyverse)
library(dplyr)

loc1S1 = read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location1otuS1.csv", sep = ',', row.names = 1, header = TRUE)
loc1S2 = read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location1otuS2.csv", sep = ',', row.names = 1, header = TRUE)
loc1S3 = read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location1otuS3.csv", sep = ',', row.names = 1, header = TRUE)

loc2S1 = read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location3otuS1.csv", sep = ',', row.names = 1, header = TRUE)
loc2S2 = read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location3otuS2.csv", sep = ',', row.names = 1, header = TRUE)
loc2S3 = read.csv("~/Desktop/Bioinformatica/Afstuderen/Naturalis/arise-soil-pilot-analysis/data/location3otuS3.csv", sep = ',', row.names = 1, header = TRUE)

S1 <- as.data.frame(t(S1))
S1 <- tibble::rownames_to_column(S1, "enummers")

S1_df <- as.data.frame(S1)
rownames(S1_df) <- S1_df$enummers
S1_df <- S1_df[,-1]

S1tt <- S1 %>%
  bind_cols(Group = rownames(S1_df),.) %>%
  select(Group, starts_with("OTU")) %>%
  pivot_longer(-Group) %>%
  mutate(total = sum(value)) %>%
  group_by(name) %>%
  mutate(total = sum(value)) %>%
  ungroup() %>%
  select(-total)

rand <- S1tt %>%
  uncount(value) %>%
  mutate(name = sample(name)) %>%
  count(Group, name, name="value")

metric_statistics <- S1tt %>%
  group_by(Group) %>%
  summarize(sobs = richness(value),
            shannon = shannon(value),
            simpson = simpson(value),
            invsimpson = 1/simpson,
            n = sum(value))

S1tt %>%
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


### Zelfde maar dan met vegan packages (random sampling)
### Simpson is voornamelijk anders
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


