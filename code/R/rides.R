# packages --------------------------------------------------
library(tidyverse)
library(dplyr)
library(ggthemes)
library(ggplot2)
library(lubridate)
library(scales)
library(inspectdf)
library(ggfortify)
library(cluster)
library(factoextra)
library(tibble)
options(scipen=999)


# read ride data
rides <- read.csv("Transportation_Network_Providers_-_Trips.csv.crdownload") %>% 
  dplyr::sample_frac(size = .1) 

# check for NAs
inspect_na(rides, show_plot = TRUE)

# summarize data types
inspect_types(rides, show_plot = TRUE)

# categories
inspect_cat(rides, show_plot = TRUE)


# filter for only Chicago rides
# Based on our data dictionary Pickup.Centroid.Latitude will be left blank for locations outside Chicago
rides.chicago <- rides %>%
  tidyr::drop_na() 

# drop original data for convenience
rides <- NA

# convert 12 hour format to 24 hr formnat and extract date features of our ride events
rides.chicago$ride_start <- as.POSIXct(rides.chicago$Trip.Start.Timestamp, format='%m/%d/%Y %I:%M:%S %p', tz = "America/Chicago") 
rides.chicago$ride_hour <- lubridate::hour(rides.chicago$ride_start)
rides.chicago$dow <- weekdays(rides.chicago$ride_start)
rides.chicago$week <- week(rides.chicago$ride_start)
rides.chicago$date_week = as.Date(cut(rides.chicago$ride_start, "week"))
rides.chicago$trip.mins = as.Date(cut(rides.chicago$ride_start, "week"))


# create category for each ride's time of day
rides.chicago <- rides.chicago %>%
  mutate(ride_category = 
           case_when(
             ride_hour >= 5 & ride_hour <= 10 ~ "morning commute",
             ride_hour > 10 & ride_hour <= 12 ~ "late_morning",
             ride_hour > 12 & ride_hour <= 17 ~ "afternoon",
             ride_hour %in% c(18,19) ~ "evening commute",
             ride_hour %in%  c(0, 1,2,3,4,20,21,22,23,24) ~ "night life")) 

# set levels for ride_category
rides.chicago$ride_category <- factor(rides.chicago$ride_category , levels = c("morning commute", 
                                                                               "late_morning", "afternoon", 
                                                                               "evening commute", "night life"))

# set levels for day of week
rides.chicago$dow <- factor(rides.chicago$dow , levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))


# trips by hour of day
ggRideCountPerHour <- rides.chicago %>%
  ggplot(aes(x=ride_hour)) + 
  geom_bar() + 
  facet_grid(~dow) +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  labs(title = "Rideshare Rides By Hour of Day",
       x = 'Hour of Day',
       y = 'Trip Count')+
  theme(axis.text.x  = element_text(size=8,angle=90)) 

ggRideCountPerHour

# tips by ride duration
ggTipsRideDuration <- rides.chicago %>%
  dplyr::sample_frac(size = .01) %>% 
  mutate(trip.mins = (Trip.Seconds/60)) %>%
  ggplot(aes(x = trip.mins, 
             y = Tip)) + 
  geom_point() +
  facet_grid(~ride_category) +
  stat_smooth(method = "lm", se = TRUE, col = "blue") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  labs(title = "Rideshare Tips By Ride Duration",
       x = 'Ride Duration (minutes)',
       y = 'Tip')

ggTipsRideDuration

# view tip amount by dow and time
ggAvgTip <- rides.chicago %>% 
  filter(Tip > 0) %>%
  ggplot(aes(x = factor(dow), 
             y = Tip)) + 
  stat_summary(fun.y = "mean", geom = "bar") +
  facet_wrap(~ride_category) +
  stat_smooth(method = "lm", se = TRUE, col = "blue") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  labs(title = "Avg Rideshare Tip By Day of Week",
       x = 'Day of Week',
       y = 'Tip')

ggAvgTip


# summarize rides by hour
RidesSummaryDay <- rides.chicago %>%
  group_by(ride_hour, dow) %>%
  mutate(rides = n()) %>%
  summarise(ride_total = first(rides),
            median_trip_cost = median(Trip.Total))

# Lets take a look a the distribution of our rides by day
ggRideVolByDay <- ggplot(RidesSummaryDay) +
  geom_density(aes(x = ride_total,
                   fill = dow),
               alpha = 0.2) +
  scale_fill_brewer(palette = "Paired") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) + 
  labs(title = "Rideshare Rides By Day of Week",
       x = "Ride Volume",
       y = "Density")

ggRideVolByDay


# ggRideByHour ----
ggRideByHour <- ggplot(RidesSummaryDay) +
  geom_smooth(aes(y = ride_total, 
                 x = ride_hour, 
                 color = dow),
             show.legend = TRUE) +
  #facet_grid(~dow) +
  scale_color_brewer(palette = "Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  ylab("Rideshare Trips") +
  xlab("Hour of Day") +
  ggtitle("Rideshare Trips by Time of Day")

ggRideByHour

# create category for each ride's time of day
rides.chicago <- rides.chicago %>%
  mutate(ride_category = 
      case_when(
      ride_hour >= 5 & ride_hour <= 10 ~ "morning commute",
      ride_hour > 10 & ride_hour <= 12 ~ "late_morning",
      ride_hour > 12 & ride_hour <= 17 ~ "afternoon",
      ride_hour %in% c(18,19) ~ "evening commute",
      ride_hour %in%  c(0, 1,2,3,4,20,21,22,23,24) ~ "night life")) 

rides.chicago$ride_category <- factor(rides.chicago$ride_category , levels = c("morning commute", 
                                                                               "late_morning", "afternoon", 
                                                                               "evening commute", "night life"))


# view trip distance by dow and time
ggTripDistance <- rides.chicago%>%
  group_by(ride_category, dow) %>%
  summarize(median_trip_dist = median(Trip.Miles)) %>%
 ggplot(aes(y = median_trip_dist, 
                x = ride_category)) +
  geom_point(aes(color = ride_category), size = 4) + 
  geom_line(aes(group=1),linetype='dotted')  +
  facet_wrap(~dow) +
  scale_color_brewer(palette = "Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  ylab("Median Trip (Miles)") +
  xlab("Day of Week") +
  ggtitle("Median Trip Distance")

ggTripDistance



# ride counts by time of day
ggRidesPerDay <- rides.chicago %>%
  group_by(dow, ride_category) %>%
  mutate(n = n()) %>%
  summarize(total_rides = first(n)) %>%
  ggplot(aes(x = ride_category,
    y = total_rides)) +
  geom_point(aes(color = ride_category), size = 4) + 
  geom_line(aes(group=1),linetype='dotted')  +
  facet_wrap(~dow) +
  scale_color_brewer(palette = "Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) +
  ylab("Trip Count") +
  xlab("Day of Week") +
  ggtitle("Ride Count By Time of Day")

ggRidesPerDay

prop.table(table(rides.chicago$ride_category))



