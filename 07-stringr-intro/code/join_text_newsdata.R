library(tidytext)
library(tidyr)
library(stringr)
library(ggplot2)
library(magrittr)
library(dplyr)
library(maps)

# Load csv of RSS feed into dataframe

ABC7 <- read.csv("abc7ny071817to011618.csv",
                         header=TRUE, stringsAsFactors=FALSE)
ABC7 %>% glimpse()

# Load in cities data from ```maps``` package.

data(us.cities)

cities <- us.cities %>%
  separate(col = name, into = c("city", "state"), sep = " ")

names(cities)[names(cities) == "city"] <- "word" # changing column name so I can join

# Tokenize headlines column and bind dataframes by city name

geo_headlines <- ABC7 %>%
  select(headline, datetime, teaser, url) %>%
  unnest_tokens(word, headline) %>%
  left_join(cities, by = "word")

geo_headlines

# maybe inner_join instead?
# maybe arrange? %>%
# maybe cut out NA values?

# Also, how do I deal with three-word cities like "New York City"?