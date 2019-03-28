#=====================================================================#
# This is code to create: loma fights from wikipedia
# Authored by and feedback to mjfrigaard@gmail.com
# MIT License
# Version: 2.1.1
#=====================================================================#

# packages -------------------------------------------------------------
library(rvest)
library(methods)
library(janitor)

# url -------------------------------------------------------------------
url <- "https://en.wikipedia.org/wiki/Vasyl_Lomachenko"


# extract tables --------------------------------------------------------
wikitables <- url %>%
  read_html() %>%
  html_nodes("table")
utils::head(wikitables)


# locate table ----------------------------------------------------------
LomaFights <- rvest::html_table(wikitables[[5]], fill = TRUE)
LomaFights %>% dplyr::glimpse(78)

# clean names ----
LomaFights <- clean_names(LomaFights)
LomaFights %>% dplyr::glimpse(78)

# make this a wide dataset for tutorial
LomaFightsWide <- LomaFights %>% 
    tidyr::spread(key = date,
                  value = result) %>% 
    dplyr::select(
        opponent,
        fight_loc = location,
        fight_number = no,
        `12 Oct 2013`, #1
        `1 Mar 2014`, #2
        `21 Jun 2014`, #3
        `22 Nov 2014`, #4
        `2 May 2015`, #5
        `7 Nov 2015`, #6
        `11 Jun 2016`, #7
        `26 Nov 2016`, #8
        `8 Apr 2017`, #9
        `5 Aug 2017`, #10
        `9 Dec 2017`, #11
        `12 May 2018`, #12
        `8 Dec 2018`, #13
        `12 Apr 2019`, #14
        result = type,
        fight_record = record,
        round_time, 
        notes)

# export LomaFightsWide ----
library(readr)
readr::write_excel_csv(as.data.frame(LomaFightsWide), na = "", path = 
                     paste0(
                         "data/",
                         base::noquote(lubridate::today()),
                         "-LomaFightsWide.csv"))

# export LomaFights ----
readr::write_excel_csv(as.data.frame(LomaFights), na = "", path = 
                     paste0(
                         "data/",
                         base::noquote(lubridate::today()),
                         "-LomaFights.csv"))