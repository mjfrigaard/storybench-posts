#=====================================================================#
# This is code to create: visualize bike share data
# Authored by and feedback to mjfrigaard@gmail.com
# MIT License
# Version: 03.3
# depends on 01.3-import & 02.3-wrangle.R
#=====================================================================#



# packages --------------------------------------------------------------
library(tidyverse)
library(rsample) # data splitting
library(randomForest) # basic implementation
library(ranger) # a faster implementation of randomForest
library(caret) # an aggregator package for performing many machine learning models
library(ggthemes)
library(scales)
library(wesanderson)
library(styler)


## ----import-BikeData--------------------------------------------------------
# and double-check to make sure it's there
# first buld an object for today's data
today_regex <- base::noquote(lubridate::today())
# today_regex
# now use this to import the data 
data_path <- fs::dir_ls(path = "data/" , regexp = today_regex)
# data_path
BikeData <- readr::read_rds(data_path)


# check BikeData
## ----BikeData-glimpse-------------------------------------------------------
# BikeData %>% dplyr::glimpse(78)


## ----BikeDplyrSummary, message=FALSE, warning=FALSE-------------------------
BikeDplyrSummary <- BikeData %>%
  select(temp, atemp, hum, windspeed, casual, registered, cnt) %>%
  summarise_each(list(
    min = ~min,
    q25 = ~quantile(., 0.25),
    median = ~median,
    q75 = ~quantile(., 0.75),
    max = ~max,
    mean = ~mean,
    sd = ~sd
  )) %>%
  gather(stat, val) %>%
  separate(stat, 
           into = c("var", "stat"), 
           sep = "_") %>%
  spread(stat, val) %>%
  select(var, min, q25, median, q75, max, mean, sd)

knitr::kable(BikeDplyrSummary)


## ----BikeSkimrSummary-------------------------------------------------------
BikeSkimrSummary <- bike %>%
  skimr::skim_to_wide() %>%
  dplyr::select(type,
    variable,
    missing,
    complete,
    min,
    max,
    mean,
    sd,
    median = p50,
    hist)
knitr::kable(BikeSkimrSummary)


## ----BikeMosaicInspect-categorical------------------------------------------
BikeMosaicInspect <- mosaic::inspect(BikeData)
# categorical
knitr::kable(BikeMosaicInspect$categorical)


## ----BikeMosaicInspect-Date-------------------------------------------------
# date 
knitr::kable(BikeMosaicInspect$Date)


## ----BikeMosaicInspect-quantitative-----------------------------------------
# quantitative 
knitr::kable(BikeMosaicInspect$quantitative)


## ----ggRentalsByTemp--------------------------------------------------------
# ~ rentals by temperature ----
ggRentalsByTemp <- BikeData %>% 
  ggplot(aes(y = cnt, 
                 x = temp, 
                 color = weekday_fct)) +
  geom_point(show.legend = FALSE) +
  geom_smooth(se = FALSE,
              show.legend = FALSE) +
  facet_grid(~weekday_fct) +
  scale_color_brewer(palette = "Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  ylab("Bike Rentals") +
  xlab("Temperature (°C)") +
  ggtitle("Bike Rental Volume By Temperature")
ggRentalsByTemp


## ----ggRentalVolByWindSpeed-------------------------------------------------
# ggRentalVolByWindSpeed ----
ggRentalVolByWindSpeed <- ggplot(bike) +
  geom_point(aes(y = cnt, 
                 x = windspeed, 
                 color = weekday_fct),
             show.legend = FALSE) +
  facet_grid(~weekday_fct) +
  scale_color_brewer(palette = "Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  ylab("Bike Rentals") +
  xlab("Windspeed") +
  ggtitle("Rental Volume By Windspeed")
ggRentalVolByWindSpeed


## ----ggRentalVolByHoliday---------------------------------------------------
ggRentalVolByHoliday <- ggplot(BikeData) +
  geom_density(aes(x = cnt,
                   fill = holiday_chr), 
                   alpha = 0.2) +
  scale_fill_brewer(palette = "Paired") +
  
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) + 
  labs(title = "Bike Rental Density By Holiday",
               fill = "Holiday",
               x = "Average Bike Rentals",
               y = "Density")

ggRentalVolByHoliday

