#=====================================================================#
# This is code to create: 03-wrangle.R
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


# previous code -----------------------------------------------------------

source("code/32.1-import.R")
source("code/32.2-tidy.R")

# change id variable
YouTubeComedyData <- YouTubeComedyDataRaw %>%
    dplyr::mutate(comedian = dplyr::case_when(
            source == 1 ~ "Amy Schumer",
            source == 2 ~ "Key & Peele"))

YouTubeComedyData <- YouTubeComedyData %>%
    # change names
    janitor::clean_names(case = "snake") %>%
    # remove Private videos
    dplyr::filter(title != "Private video") %>%
    # reorganize
    dplyr::select(comedian,
                  dplyr::everything(),
                  -c(source))

AmySchumer <- AmySchumerRaw %>%
    # change names
    janitor::clean_names(case = "snake") %>%
    # remove Private videos
    dplyr::filter(title != "Private video")

KeyAndPeele <- KeyAndPeeleRaw %>%
    # change names
    janitor::clean_names(case = "snake") %>%
    # remove Private videos
    dplyr::filter(title != "Private video")


# export wrangled data  ---------------------------------------------

readr::write_csv(x = as.data.frame(x = YouTubeComedyData),
                 path = paste0(
    "data/",
    base::noquote(lubridate::today()),
    "-YouTubeComedyData.csv"))

readr::write_csv(x = as.data.frame(x = AmySchumer),
                 path = paste0(
    "data/",
    base::noquote(lubridate::today()),
    "-AmySchumer.csv"))

readr::write_csv(x = as.data.frame(x = KeyAndPeele),
                 path = paste0(
    "data/",
    base::noquote(lubridate::today()),
    "-KeyAndPeele.csv"))