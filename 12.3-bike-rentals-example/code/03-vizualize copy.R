library(tidyverse)
library(rsample) # data splitting
library(randomForest) # basic implementation
library(ranger) # a faster implementation of randomForest
library(caret) # an aggregator package for performing many machine learning models
library(ggthemes)
library(scales)
library(wesanderson)
library(styler)

# EDA
bike_dplyr_summary <- bike %>%
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

knitr::kable(bike_dplyr_summary)

bike_summary_skim <- bike %>%
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
knitr::kable(bike_summary_skim)

# mosaic::inspect -----------------------------------------------------
bike_inspect <- mosaic::inspect(bike)

# categorical
knitr::kable(bike_inspect$categorical)

# categorical
knitr::kable(bike_inspect$quantitative)

# vizualize
# rentals by temperature
ggplot(bike) +
  geom_point(aes(y=cnt,x=temp,color=weekday_ch))+
  facet_grid(~weekday_ch)+
  scale_color_brewer(palette="Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  ylab('Bike Rentals')+
  xlab('Temperature (°C)')+
  ggtitle('Bike Rental Volume By Temperature')

# rentals by windspeed
ggplot(bike)+
  geom_point(aes(y=cnt,x=windspeed,color=weekday_ch))+
  facet_grid(~weekday_ch)+
  scale_color_brewer(palette="Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  ylab('Bike Rentals')+
  xlab('Wind Speed')+
  ggtitle('Rental Volume By Wind Speed')

ggplot(bike) +
  geom_point(aes(y=cnt, x=hum, color =weekday_ch)) +
  facet_grid(~ weekday_ch) +
  scale_color_brewer(palette="Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  ylab('Bike Rentals')+
  xlab('Humidity')+
  ggtitle('Rental Volume By Humidity')

ggplot(bike) +
  geom_boxplot(aes(y=cnt, x=temp, color =weekday_ch)) +
  facet_grid(~ weekday_ch) +
  scale_color_brewer(palette="Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  ylab('Bike Rentals')+
  xlab('Temperature (°C)')+
  ggtitle('Rental Volume By Temperature')

ggplot(bike) +
  geom_boxplot(aes(y=cnt, x=temp, color =season_ch)) +
  facet_grid(~ season_ch) +
  scale_color_brewer(palette="Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  ylab('Bike Rentals')+
  xlab('Temperature (°C)')+
  ggtitle('Rental Volume By Temperature')


density <- ggplot(bike) +
  geom_density(aes(x=cnt,fill=holiday_ch),alpha=0.2)+
  scale_fill_brewer(palette="Paired") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

density + labs(title = "Bike Rental Density By Holiday",
               fill = "Holiday",
               x = "Average Bike Rentals",
               y = "Density")


weather <- bike %>%
  filter(!mnth_ch %in% c('May', 'June', 'August')) %>%
  ggplot(data=., aes(x=mnth_ch, y=cnt, fill = weathersit_ch)) +
  stat_summary(fun.y=mean, geom="bar") +
  stat_summary(fun.data=mean_cl_boot, geom="errorbar", width=0.3) +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  theme(legend.position = 'none') +
  coord_flip() +
  facet_wrap(~ weathersit_ch)

weather + labs(title = "Averge Bike Rentals By Weather",
               subtitle = "It's not the season, it's the weather",
               x = "Average Bike Rentals", y = "Month")



line <- ggplot(bike, aes(dteday, cnt, colour = holiday_ch)) +
  geom_line() +
  theme_fivethirtyeight() +
  theme(axis.title = element_text())

line + labs(title = "Count of Bike Rentals",
            fill = "Holiday",
            x = "Date",
            y = "Bike Rentals")
