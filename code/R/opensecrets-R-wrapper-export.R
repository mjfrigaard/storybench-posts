
library(jsonlite)
library(tidyverse)
library(magrittr)

opensecquery2 <- jsonlite::fromJSON('https://www.opensecrets.org/api/?method=candContrib&output=json&apikey=83ca538c93a250f44232b2ef96c9bb25&cid=N00033492')

str(opensecquery2)
# List of 1

tidy_candContribData <- opensecquery2$response$contributors$contributor
tidy_candContribData %>% str()
str(tidy_candContribData)



