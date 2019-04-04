


# VISUALIZE ----
# ~ rentals by temperature ----
ggplot(bike) +
  geom_point(aes(y = cnt, x = temp, color = weekday)) +
  facet_grid(~weekday) +
  scale_color_brewer(palette = "Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  ylab("Bike Rentals") +
  xlab("Temperature (°C)") +
  ggtitle("Bike Rental Volume By Temperature")

# maybe start at monday?

# ~ rentals by windspeed ----
ggplot(bike) +
  geom_point(aes(y = cnt, x = windspeed, color = weekday)) +
  facet_grid(~weekday) +
  scale_color_brewer(palette = "Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  ylab("Bike Rentals") +
  xlab("Windspeed") +
  ggtitle("Rental Volume By Windspeed")

# ~ rentals by humidity ----
ggplot(bike) +
  geom_point(aes(y = cnt, x = hum, color = weekday)) +
  facet_grid(~weekday) +
  scale_color_brewer(palette = "Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  ylab("Bike Rentals") +
  xlab("Humidity") +
  ggtitle("Rental Volume By Humidity")

# ~ rentals by Tempterature ----
ggplot(bike) +
  geom_boxplot(aes(y = cnt, x = temp, color = weekday)) +
  facet_grid(~weekday) +
  scale_color_brewer(palette = "Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  ylab("Bike Rentals") +
  xlab("Temperature (°C)") +
  ggtitle("Rental Volume By Temperature")

ggplot(bike) +
  geom_boxplot(aes(y = cnt, x = temp, color = season)) +
  facet_grid(~season) +
  scale_color_brewer(palette = "Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  ylab("Bike Rentals") +
  xlab("Temperature (°C)") +
  ggtitle("Rental Volume By Temperature")

ggplot(bike) +
  geom_density(aes(x = cnt, fill = holiday), alpha = 0.2) +
  scale_color_brewer(palette = "Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  xlab("Bike Rentals") +
  ylab("Density") +
  ggtitle("Bike Rental Distribution")


# ~ average Bike Rentals ----------------------------------------

plot_labs <- ggplot2::labs(
      # tag = "#tidyverse"
      title = "Bike Rentals Depend on Weather Conditions", 
        subtitle = "It's not the season--it's the weather!",
        x = "Month",
        y = "Bike Rentals", 
        caption = "#tidyverse #rstats")

bike %>%
  # remove vector for months with no rain/snow/storm
  filter(!mnth %in% c('May', 'June', 'August')) %>%
  ggplot(data = ., aes(x = mnth, y = cnt, 
                       fill = weathersit)) +
  stat_summary(fun.y = mean, 
               geom = "bar") +
  # removed fill = "color" and add fill to aes()^
  stat_summary(fun.data = mean_cl_boot, 
               geom = "errorbar", 
               width = 0.3) +
  theme_fivethirtyeight() +
  # this adds a legend and removes some axis ticks, etc. 
  # blank option comes after 
  theme(legend.position = "none") +
  coord_flip() +
  facet_wrap(~weathersit) +
  plot_labs
  

# ~ count of bike rentals ---------------------------------------
ggplot(bike, aes(dteday, 
                 cnt, 
                 colour = holiday)) +
  geom_line() +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  theme(legend.title = element_blank()) +
   guides(fill = guide_legend(title = " ", 
                  title.position = "left")) +
  xlab("Date") +
  ylab("Bike Rentals") +
  ggtitle("Bike Rentals Count over Time")