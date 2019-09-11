#=====================================================================#
# This is code to create: import
# Authored by and feedback to:
# MIT License
# Version:
#=====================================================================#


# packages ----------------------------------------------------------------

library(magrittr) # Pipes %>%, %T>% and equals(), extract().
library(tidyverse) # all tidyverse packages
library(fs) # file management functions
library(fivethirtyeight)
library(mdsr) # modern data science with R
library(broom) # tidying models
library(modelr) # modelr package
library(ggrepel) # repel text overlay in graphs
library(gridExtra) # arrange multiple plots
library(grid) # text for graph title
library(egg) # for ggarrange
library(corrr) # correlations
# devtools::install_github("ropensci/skimr", ref = "v2")
library(skimr)

# download key and peele
utils::download.file(
  url =
    "https://raw.githubusercontent.com/richardcornish/sketch-comedy-data/master/csvs/amy.csv",
  destfile = paste0(
    "data/",
    base::noquote(lubridate::today()),
    "-amy-schumer.csv"
  )
)
# download amy schumer
utils::download.file(
  url =
    "https://raw.githubusercontent.com/richardcornish/sketch-comedy-data/master/csvs/kap.csv",
  destfile = paste0(
    "data/",
    base::noquote(lubridate::today()),
    "-key-and-peele.csv"
  )
)

# import raw .csvs
AmySchumerRaw <- readr::read_csv(paste0(
  "data/",
  base::noquote(lubridate::today()),
  "-amy-schumer.csv"
))

KeyAndPeeleRaw <- readr::read_csv(paste0(
  "data/",
  base::noquote(lubridate::today()),
  "-key-and-peele.csv"
))