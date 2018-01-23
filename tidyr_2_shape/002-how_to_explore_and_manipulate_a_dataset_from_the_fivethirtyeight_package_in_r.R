## ----setup, include=FALSE------------------------------------------------
require(tidyverse)
knitr::opts_chunk$set(
    echo = TRUE, # show all code
    tidy = FALSE, # cleaner code printing
    size = "small") # smaller code

## ----packages, message=FALSE, warning=FALSE------------------------------
download.file(url = "https://tinyurl.com/ya99kpcz", 
              destfile = "./F01-install_my_pkgs.R") # download my packages 
                                                    # from github
source("./F01-install_my_pkgs.R") # load them 

## ----file_name-----------------------------------------------------------
file_number <- c("002") # version # 2
file_exten <- c(".Rmd")
file_title <- tolower(str_replace_all(
    "How to explore and manipulate a dataset from the fivethirtyeight package in R", 
    pattern = " ",
    replacement = "_"))
file_name <- paste0(file_number, "-", file_title, file_exten)
file_name
options(width = 80)

## ----packages_2----------------------------------------------------------
library(fivethirtyeight)
library(tidyr)
library(tibble)
library(dplyr)
murder_2015_final <- fivethirtyeight::murder_2015_final %>% tbl_df()
murder_2015_final %>% glimpse()

## ----names---------------------------------------------------------------
# See names of columns
names(murder_2015_final)

## ----murders_gathered, results='hide'------------------------------------
murders_gathered <- murder_2015_final %>% 
    gather(
        key = murder_year,
        value = murders,
        murders_2014:murders_2015,
        na.rm = TRUE)
murders_gathered

## ----murders_arranged, results='hide'------------------------------------
murders_arranged <- murders_gathered %>% 
    arrange(
        state, 
        city)
murders_arranged

## ----murders_separate, results='hide'------------------------------------
murders_separate <- murders_arranged %>%
    separate(
        murder_year,
            into = c("text", 
                     "year")
        )
murders_separate

## ----murders_spread, results='hide'--------------------------------------
murders_spread <- murders_separate %>% 
    spread(
        year,
        murders
        ) %>% 
        arrange(
            state,
            city)
murders_spread

## ----murders_final-------------------------------------------------------
murders_final <- murders_spread %>%
unite(
    city_state, 
    city, 
    state) %>% 
        arrange(
            city_state
            ) %>% 
            select(
                -(text)
                )
murders_final

## ----write.csv, results='hide'-------------------------------------------
write.csv(murders_final, file = "murders_final.csv",row.names = FALSE, na = "")

## ----geom_bar------------------------------------------------------------
barplot(murders_final$change)
# murders_final %>% ggplot(aes(change)) + geom_bar()

## ----murders_final_sort--------------------------------------------------
murders_final_sort <- murders_final %>% 
  arrange(
    change)
murders_final_sort

## ----sorted_barplot------------------------------------------------------
barplot(murders_final_sort$change)

## ----ylim----------------------------------------------------------------
barplot(murders_final_sort$change,
        ylim = c(-20, 120))

## ----midpts--------------------------------------------------------------
midpts <- barplot(murders_final_sort$change,
                  cex.axis = 1.0, 
                  cex.names = 0.6,
                  ylim = c(-20, 120), 
                  main = "Change in murders from 2014 to 2015")

text(murders_gathered$city,
     x = midpts,
     offset = -0.1,
     y = -20,
     cex = 0.5,
     srt = 60,
     xpd = TRUE,
     pos = 2) 

