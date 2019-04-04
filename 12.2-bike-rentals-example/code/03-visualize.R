#=====================================================================#
# This is code to create: wrangle bike share data
# Authored by and feedback to mjfrigaard@gmail.com
# MIT License
# Version: 1.0
# depends on 02-wrangle.R
#=====================================================================#

library(tidyverse)
library(rsample) # data splitting
library(randomForest) # basic implementation
library(ranger) # a faster implementation of randomForest
library(caret) # an aggregator package for performing many machine learning models
library(ggthemes)
library(scales)
library(wesanderson)
library(styler)


# create exploratory analysis table for continuous data
BikeDplyrSummary <- BikeData %>%
  select(temp, 
         atemp, 
         hum, 
         windspeed, 
         casual, 
         registered, 
         cnt) %>%
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

# skimr::skim() ----
BikeSkimrSummary <- BikeData %>%
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

# mosaic::inspect -----------------------------------------------------
BikeMosaicInspect <- mosaic::inspect(BikeData)

# VISUALIZE ----
# rentals by temperature
ggplot(BikeData) +
  geom_point(aes(y = cnt, x = temp, color = weekday_chr)) +
  facet_grid(~weekday_chr) +
  scale_color_brewer(palette = "Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  ylab("Bike Rentals") +
  xlab("Temperature (°C)") +
  ggtitle("Bike Rental Volume By Temperature")

# rentals by windspeed
ggplot(BikeData) +
  geom_point(aes(y = cnt, x = windspeed, color = weekday_chr)) +
  facet_grid(~weekday_chr) +
  scale_color_brewer(palette = "Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  ylab("Bike Rentals") +
  xlab("Wind Speed") +
  ggtitle("Rental Volume By Wind Speed")

ggplot(BikeData) +
  geom_point(aes(y = cnt, x = hum, color = weekday_chr)) +
  facet_grid(~weekday_chr) +
  scale_color_brewer(palette = "Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  ylab("Bike Rentals") +
  xlab("Humidity") +
  ggtitle("Rental Volume By Humidity")

ggplot(BikeData) +
  geom_boxplot(aes(y = cnt, x = temp, color = weekday_chr)) +
  facet_grid(~weekday_chr) +
  scale_color_brewer(palette = "Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  ylab("Bike Rentals") +
  xlab("Temperature (°C)") +
  ggtitle("Rental Volume By Temperature")

ggplot(BikeData) +
  geom_boxplot(aes(y = cnt, x = temp, color = season_chr)) +
  facet_grid(~season_chr) +
  scale_color_brewer(palette = "Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  ylab("Bike Rentals") +
  xlab("Temperature (°C)") +
  ggtitle("Rental Volume By Temperature")


density <- ggplot(BikeData) +
  geom_density(aes(x = cnt, fill = holiday_chr), alpha = 0.2) +
  scale_fill_brewer(palette = "Paired") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

density + labs(
  title = "Bike Rental Density By Holiday",
  fill = "Holiday",
  x = "Average Bike Rentals",
  y = "Density"
)


weather <- BikeData %>%
  # drop empty months
  filter(!month_ord %in% c("May", "June", "August")) %>%
  
  ggplot(data = ., aes(x = month_ord, y = cnt, fill = weathersit_chr)) +
  stat_summary(fun.y = mean, geom = "bar") +
  stat_summary(fun.data = mean_cl_boot, geom = "errorbar", width = 0.3) +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  theme(legend.position = "none") +
  coord_flip() +
  facet_wrap(~weathersit_chr)

weather + labs(
  title = "Averge Bike Rentals By Weather",
  subtitle = "It's not the season, it's the weather",
  x = "Average Bike Rentals", y = "Month"
)

line <- ggplot(BikeData, aes(dteday, cnt, colour = holiday_chr)) +
  geom_line() +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

line + labs(
  title = "Count of Bike Rentals",
  fill = "Holiday",
  x = "Date",
  y = "Bike Rentals"
)

