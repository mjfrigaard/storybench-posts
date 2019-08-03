#=====================================================================#
# This is code to create: loma fights from wikipedia
# Authored by and feedback to mjfrigaard@gmail.com
# MIT License
# Version: 1.3
#=====================================================================#

# packages -------------------------------------------------------------
library(rvest)
library(methods)
library(janitor)
library(tidyverse)
library(magrittr)

# url -------------------------------------------------------------------
url <- "https://en.wikipedia.org/wiki/Vasyl_Lomachenko"


# extract tables --------------------------------------------------------
wikitables <- url %>%
  read_html() %>%
  html_nodes("table")
utils::head(wikitables)


# locate table ----------------------------------------------------------
LomaFights <- rvest::html_table(wikitables[[5]], fill = TRUE)
# LomaFights %>% dplyr::glimpse(78)

# clean names ----
LomaFights <- clean_names(LomaFights)

# clean dates ----
LomaFights <- LomaFights %>% 
    dplyr::mutate(date = lubridate::dmy(date)) %>% 
    dplyr::arrange(date)

LomaFights <- LomaFights %>% 
    tidyr::separate( col = round_time, 
                    into = c("rounds", "time"),
                    sep = ", ",
                    extra = "drop")
# replace N/As ----
LomaFights <-  LomaFights %>% 
     dplyr::mutate(result = na_if(LomaFights$result, "N/A"),
                   record = na_if(LomaFights$record, "N/A"),
                   type = na_if(LomaFights$type, "N/A"),
                   rounds = na_if(LomaFights$rounds, "– (12)"))

# LomaFights %>% dplyr::glimpse(78)

# LomaFightWide ---------------------------------------------------------
# make this a wide dataset for tutorial
LomaFightsWide <- LomaFights %>% 
    tidyr::spread(key = no,
                  value = result)

LomaFightsWide <- LomaFightsWide %>% 
    dplyr::arrange(date) %>% magrittr::set_names(x = ., 
                        value = c("record", "opponent", "type", 
                                  "rounds", "time", "date", "location", 
                                  "notes", "fight_1", "fight_2", 
                                  "fight_3", "fight_4", "fight_5",
                                  "fight_6", "fight_7", "fight_8", 
                                  "fight_9", "fight_10", "fight_11",
                                  "fight_12", "fight_13", "fight_14",
                                  "fight_15"))

LomaFightsWide <- LomaFightsWide %>%
    dplyr::select(
        opponent,
        location,
        date,
        dplyr::starts_with("fight"),
        type,
        record,
        rounds,
        time, 
        notes)

# LomaFightsWide %>% dplyr::glimpse(78)

# LomaWideSmall --------------------------------------------------------
LomaWideSmall <- LomaFightsWide %>% 
    dplyr::select(opponent,
                  date,
                  dplyr::starts_with("fight")) 

# LomaWideSmall %>% dplyr::glimpse(78)

# LomaDatesWide --------------------------------------------------------
# make wide dataset for tutorial by date
LomaDatesWide <- LomaFights %>%
    tidyr::spread(key = date,
                  value = result) %>% 
    dplyr::select(
        opponent,
        fight_loc = location,
        fight_number = no,
        dplyr::starts_with("20"),
        result = type,
        fight_record = record,
        rounds,
        time, 
        notes)

# LomaDatesWide %>% dplyr::glimpse(78)

readr::write_rds(x = LomaDatesWide, path = paste0(
    "data/",
    base::noquote(lubridate::today()),
    "-LomaDatesWide.rds"))

# Indexed ---------------------------------------------------------------

Indexed <- tibble::tribble(~group, ~number, ~measure,
                                 "A", "ID001",     1098,
                                 "C", "ID001",     3049,
                                 "D", "ID003",     2394,
                                 "B", "ID004",     9301,
                                 "C", "ID006",     4092)

# Cartesian ---------------------------------------------------------------
Cartesian <- tibble::tribble(~group, ~ID001, ~ID003, ~ID004, ~ID006,
                                  "A",   1098,     NA,     NA,     NA,
                                  "B",     NA,     NA,   9301,     NA,
                                  "C",   3049,     NA,     NA,   4092,
                                  "D",     NA,   2394,     NA,     NA)

# DataTibble ----
DataTibble <- tibble::tribble(
    ~group_var, ~year, ~x_measurement, ~y_measurement, ~ordinal_y_var,
           "A",  2018,          11.81,         532.37,            2,
           "A",  2017,          28.46,         116.04,            1,
           "A",  2016,          49.15,         304.21,            1,
           "B",  2018,          87.56,         719.38,            2,
           "B",  2017,          11.33,         984.38,            3,
           "C",  2018,          15.87,         959.41,            3,
           "C",  2017,          63.76,         962.27,            3,
           "C",  2016,          96.03,         744.52,            2) %>% 
  dplyr::mutate(ordinal_y_var = base::factor(ordinal_y_var,
    labels = c(
      "high",
      "med",
      "low"),
    levels = c(3, 2, 1)))