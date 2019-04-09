#=====================================================================#
# This is code to create: wrangle bike share data
# Authored by and feedback to mjfrigaard@gmail.com
# MIT License
# Version: 1.0
# depends on 01-import.R
#=====================================================================#

library(tidyverse)
library(skimr)
library(janitor)

source("code/01-import.R")
ls()

# WRANGLE ---------------------------------------------------------------
# I like to be overly cautious when it comes to wrangling because all models
# are only as good as the underlying data. This data set came with many
# categorical variables coded numerically, so I am going to create a 
# character version of each variable (_chr) and a factor version (_fct).
# Creating a character and factor variable will let me choose which one to 
# use for each graph and model.

# this recodes the weekday variable into a character variable
# test 
# bike %>%
#   mutate(
#     weekday_chr =
#       case_when(
#         weekday == 0 ~ "Sunday",
#         weekday == 1 ~ "Monday",
#         weekday == 2 ~ "Tuesday",
#         weekday == 3 ~ "Wednesday",
#         weekday == 4 ~ "Thursday",
#         weekday == 5 ~ "Friday",
#         weekday == 6 ~ "Saturday",
#         TRUE ~ "other")) %>% 
#     dplyr::count(weekday, weekday_chr) %>%
#     tidyr::spread(weekday, n)

# assign
bike <- bike %>%
  mutate(
    weekday_chr =
      case_when(
        weekday == 0 ~ "Sunday",
        weekday == 1 ~ "Monday",
        weekday == 2 ~ "Tuesday",
        weekday == 3 ~ "Wednesday",
        weekday == 4 ~ "Thursday",
        weekday == 5 ~ "Friday",
        weekday == 6 ~ "Saturday",
        TRUE ~ "other"))

# verify
# bike %>% 
#   dplyr::count(weekday, weekday_chr) %>% 
#   tidyr::spread(weekday, n)

# Weekdays (factor) ---

# test factor variable
# bike %>%
#   mutate(
#     weekday_fct = factor(x = weekday,
#              levels = c(0,1,2,3,4,5,6),
#              labels = c("Sunday",
#                        "Monday",
#                        "Tuesday",
#                        "Wednesday",
#                        "Thursday",
#                        "Friday",
#                        "Saturday"))) %>%
#   dplyr::count(weekday, weekday_fct) %>%
#   tidyr::spread(weekday, n)

# assign factor variable
bike <- bike %>%
  mutate(
    weekday_fct = factor(x = weekday,
             levels = c(0,1,2,3,4,5,6),
             labels = c("Sunday",
                       "Monday",
                       "Tuesday",
                       "Wednesday",
                       "Thursday",
                       "Friday",
                       "Saturday")))

# verify factor variable
# bike %>% 
#   dplyr::count(weekday, weekday_fct) %>% 
#   tidyr::spread(weekday, n)


# Holidays ----
# test
# bike %>%
#   mutate(holiday_chr =
#       case_when(
#         holiday == 0 ~ "Non-Holiday",
#         holiday == 1 ~ "Holiday")) %>% 
#   dplyr::count(holiday, holiday_chr) %>%
#   tidyr::spread(holiday, n)

# assign
bike <- bike %>%
  mutate(holiday_chr =
      case_when(
        holiday == 0 ~ "Non-Holiday",
        holiday == 1 ~ "Holiday"))

# verify
# bike %>%
#   dplyr::count(holiday, holiday_chr) %>%
#   tidyr::spread(holiday, n)

# test
# bike %>%
#   mutate(
#     holiday_fct = factor(x = holiday,
#              levels = c(0,1),
#              labels = c("Non-Holiday",
#                        "Holiday"))) %>% 
#     dplyr::count(holiday, holiday_fct) %>%
#     tidyr::spread(holiday, n)

# assign
bike <- bike %>%
  mutate(
    holiday_fct = factor(x = holiday,
             levels = c(0,1),
             labels = c("Non-Holiday",
                       "Holiday")))

# # verify
# bike %>%
#   dplyr::count(holiday_chr, holiday_fct) %>%
#   tidyr::spread(holiday_chr, n)

# Working days ----
# test
 # bike %>%
 #  mutate(
 #    workingday_chr =
 #      case_when(
 #        workingday == 0 ~ "Non-Working Day",
 #        workingday == 1 ~ "Working Day",
 #        TRUE ~ "other")) %>% 
 #    dplyr::count(workingday, workingday_chr) %>%
 #    tidyr::spread(workingday, n)

# assign
 bike <- bike %>%
  mutate(
    workingday_chr =
      case_when(
        workingday == 0 ~ "Non-Working Day",
        workingday == 1 ~ "Working Day",
        TRUE ~ "other")) 
 
 # verify
 # bike %>% 
 #    dplyr::count(workingday, workingday_chr) %>%
 #    tidyr::spread(workingday, n)
   
# test
# bike %>%
#   mutate(
#     workingday_fct = factor(x = workingday,
#              levels = c(0,1),
#              labels = c("Non-Working Day",
#                        "Working Day"))) %>%
#   dplyr::count(workingday, workingday_fct) %>%
#   tidyr::spread(workingday, n)

# assign
bike <- bike %>%
  mutate(
    workingday_fct = factor(x = workingday,
             levels = c(0,1),
             labels = c("Non-Working Day",
                       "Working Day")))

# verify
# bike %>%
#   dplyr::count(workingday_chr, workingday_fct) %>%
#   tidyr::spread(workingday_chr, n)


# Seasons
bike <- bike %>%
  mutate(
    season_chr =
      case_when(
        season == 1 ~ "Spring",
        season == 2 ~ "Summer",
        season == 3 ~ "Fall",
        season == 4 ~ "Winter",
        TRUE ~ "other"
      ))

# test
# bike %>%
#   mutate(
#     season_fct = factor(x = season,
#              levels = c(1, 2, 3, 4),
#              labels = c("Spring",
#                        "Summer",
#                        "Fall",
#                        "Winter"))) %>%
#   dplyr::count(season_chr, season_fct) %>%
#   tidyr::spread(season_chr, n)

# assign
bike <- bike %>%
  mutate(
    season_fct = factor(x = season,
             levels = c(1, 2, 3, 4),
             labels = c("Spring",
                       "Summer",
                       "Fall",
                       "Winter"))) 

# verify
# bike %>%
#   dplyr::count(season_chr, season_fct) %>%
#   tidyr::spread(season_chr, n)


# Weather situation ----
# test
# bike %>%
#   mutate(
#     weathersit_chr =
#       case_when(
#         weathersit == 1 ~ "Good",
#         weathersit == 2 ~ "Clouds/Mist",
#         weathersit == 3 ~ "Rain/Snow/Storm",
#         TRUE ~ "other")) %>% 
#   dplyr::count(weathersit, weathersit_chr) %>%
#   tidyr::spread(weathersit, n)

# assign
bike <- bike %>%
  mutate(
    weathersit_chr =
      case_when(
        weathersit == 1 ~ "Good",
        weathersit == 2 ~ "Clouds/Mist",
        weathersit == 3 ~ "Rain/Snow/Storm"))

# verify
# bike %>% 
#   dplyr::count(weathersit, weathersit_chr) %>%
#   tidyr::spread(weathersit, n)

# test
# bike %>%
#   mutate(
#     weathersit_fct = factor(x = weathersit,
#              levels = c(1, 2, 3),
#              labels = c("Good",
#                        "Clouds/Mist",
#                        "Rain/Snow/Storm"))) %>%
#   dplyr::count(weathersit, weathersit_fct) %>%
#   tidyr::spread(weathersit, n)

# assign 
bike <- bike %>%
  mutate(
    weathersit_fct = factor(x = weathersit,
                       levels = c(1, 2, 3),
                       labels = c("Good",
                                 "Clouds/Mist",
                                 "Rain/Snow/Storm")))
# verify
# bike %>%
#   dplyr::count(weathersit_chr, weathersit_fct) %>%
#   tidyr::spread(weathersit_chr, n)


# Months ----
# huge shoutout to Thomas Mock over at RStudio for showing me 
# lubridate::month() (and stopping my case_when() obsession)
# https://twitter.com/thomas_mock/status/1113105497480183818

# test 
# bike %>% 
#   mutate(month_ord = 
#            lubridate::month(mnth, label = TRUE)) %>% 
#   dplyr::count(month_ord, mnth) %>% 
#   tidyr::spread(month_ord, n)

# assign
bike <- bike %>% 
  mutate(month_ord = 
           lubridate::month(mnth, label = TRUE))

# verify
# bike %>% 
#   dplyr::count(month_ord, mnth) %>% 
#   tidyr::spread(month_ord, n)
  

# test
# bike %>%
#   mutate(
#     month_fct = factor(x = mnth,
#              levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12),
#              labels = c("January", "February", "March", "April", "May",
#                         "June", "July", "August", "September", "October",
#                         "November", "December"))) %>%
#   dplyr::count(mnth, month_fct) %>%
#   tidyr::spread(month_fct, n)

# assign
bike <- bike %>%
  mutate(
    month_fct = factor(x = mnth,
             levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12),
             labels = c("January", "February", "March", "April", "May",
                        "June", "July", "August", "September", "October",
                        "November", "December")))

# verify
# bike %>% 
#   dplyr::count(month_chr, month_fct) %>%
#   tidyr::spread(month_fct, n)

# Year ----
# test
# bike %>%
#   mutate(
#     yr_chr =
#       case_when(
#         yr == 0 ~ "2011",
#         yr == 1 ~ "2012",
#         TRUE ~ "other")) %>% 
#     dplyr::count(yr, yr_chr) %>%
#     tidyr::spread(yr, n)

# assign
bike <- bike %>%
  mutate(
    yr_chr =
      case_when(
        yr == 0 ~ "2011",
        yr == 1 ~ "2012"))
# verify
# bike %>%
#     dplyr::count(yr, yr_chr) %>%
#     tidyr::spread(yr, n)

# test
# bike %>%
#   mutate(
#     yr_fct = factor(x = yr,
#              levels = c(0, 1),
#              labels = c("2011",
#                        "2012"))) %>%
#   dplyr::count(yr, yr_fct) %>%
#   tidyr::spread(yr, n)

# assign
bike <- bike %>%
  mutate(
    yr_fct = factor(x = yr,
             levels = c(0, 1),
             labels = c("2011",
                       "2012")))
# verify
# bike %>%
#   dplyr::count(yr_chr, yr_fct) %>%
#   tidyr::spread(yr_chr, n)

# normalize temperatures ----
bike <- bike %>%
  mutate(temp = as.integer(temp * (39 - (-8)) + (-8)))

bike <- bike %>%
  mutate(atemp = atemp * (50 - (16)) + (16))

# ~ windspeed ----
bike <- bike %>%
  mutate(windspeed = as.integer(67 * bike$windspeed))

# ~ humidity ----
bike <- bike %>%
  mutate(hum = as.integer(100 * bike$hum))

# ~ convert to date ----
bike <- bike %>%
  mutate(dteday = as.Date(dteday))

# check df
# bike %>% dplyr::glimpse(78)

# rename the data frame so these don't get confused
BikeData <- bike

# reorganize variables for easier inspection

BikeData <- BikeData %>% 
  dplyr::select(
    dplyr::starts_with("week"),
    dplyr::starts_with("holi"),
    dplyr::starts_with("seas"),
    dplyr::starts_with("work"),
    dplyr::starts_with("month"),
    dplyr::starts_with("yr"),
    dplyr::starts_with("weath"),
    dplyr::everything())


# export ----------------------------------------------------------------
# first buld an object for today's data
today_regex <- base::noquote(lubridate::today())
today_regex

# now export data with timestamp
readr::write_rds(BikeData, paste0(
  "data/",
  today_regex,
  "-BikeData.rds"))

# and double-check to make sure it's there
fs::dir_ls(path = "data/" , regexp = today_regex)

# END -----