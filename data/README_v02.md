The Bike Rental Boom Is Here: Predicting Bike Rental Behaviour in a
Metropolitan City
================

# Motivation

``` r
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
```

# Import

``` r
# read data of bike rentals daily ----
bike <- read.csv("day.csv")
```

# Wrangle

``` r
# WRANGLE ---------------------------------------------------------------

# recode with labels and make factor
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
        TRUE ~ "other"
      )
  )
```

## Weekdays

``` r
bike %>%
  mutate(
    weekday_fct = factor(x = weekday,
             labels = c(0,1,2,3,4,5,6),
             levels = c("Sunday",
                       "Monday",
                       "Tuesday",
                       "Wednesday",
                       "Thursday",
                       "Friday",
                       "Saturday"))) %>%
  dplyr::count(weekday, weekday_fct) %>% 
  tidyr::spread(weekday, n)
```

    ## Warning: Factor `weekday_fct` contains implicit NA, consider using
    ## `forcats::fct_explicit_na`

    ## # A tibble: 1 x 8
    ##   weekday_fct   `0`   `1`   `2`   `3`   `4`   `5`   `6`
    ##   <fct>       <int> <int> <int> <int> <int> <int> <int>
    ## 1 <NA>          105   105   104   104   104   104   105

``` r
# assign 
bike <- bike %>%
  mutate(
    weekday_fct = factor(x = weekday,
             labels = c(0,1,2,3,4,5,6),
             levels = c("Sunday",
                       "Monday",
                       "Tuesday",
                       "Wednesday",
                       "Thursday",
                       "Friday",
                       "Saturday")))
```

## Holidays

``` r
bike <- bike %>%
  mutate(
    holiday_chr =
      case_when(
        holiday == 0 ~ "Non-Holiday",
        holiday == 1 ~ "Holiday",
        TRUE ~ "other"
      )
  )

bike %>% 
  dplyr::count(holiday, holiday_chr) %>% 
  tidyr::spread(holiday, n)
```

    ## # A tibble: 2 x 3
    ##   holiday_chr   `0`   `1`
    ##   <chr>       <int> <int>
    ## 1 Holiday        NA    21
    ## 2 Non-Holiday   710    NA

## Working days

``` r
bike <- bike %>%
  mutate(
    workingday_chr =
      case_when(
        workingday == 0 ~ "Non-Working Day",
        workingday == 1 ~ "Working Day",
        TRUE ~ "other"
      )
  )

bike %>% 
  dplyr::count(workingday, workingday_chr) %>% 
  tidyr::spread(workingday, n)
```

    ## # A tibble: 2 x 3
    ##   workingday_chr    `0`   `1`
    ##   <chr>           <int> <int>
    ## 1 Non-Working Day   231    NA
    ## 2 Working Day        NA   500

## Seasons

``` r
bike <- bike %>%
  mutate(
    season_chr =
      case_when(
        season == 1 ~ "Spring",
        season == 2 ~ "Summer",
        season == 3 ~ "Fall",
        season == 4 ~ "Winter",
        TRUE ~ "other"
      )
  )

bike %>% 
  dplyr::count(season, season_chr) %>% 
  tidyr::spread(season, n)
```

    ## # A tibble: 4 x 5
    ##   season_chr   `1`   `2`   `3`   `4`
    ##   <chr>      <int> <int> <int> <int>
    ## 1 Fall          NA    NA   188    NA
    ## 2 Spring       181    NA    NA    NA
    ## 3 Summer        NA   184    NA    NA
    ## 4 Winter        NA    NA    NA   178

## Weather situation

``` r
bike <- bike %>%
  mutate(
    weathersit_chr =
      case_when(
        weathersit == 1 ~ "Good",
        weathersit == 2 ~ "Clouds/Mist",
        weathersit == 3 ~ "Rain/Snow/Storm",
        TRUE ~ "other"
      )
  )

bike %>% 
  dplyr::count(weathersit, weathersit_chr) %>% 
  tidyr::spread(weathersit, n)
```

    ## # A tibble: 3 x 4
    ##   weathersit_chr    `1`   `2`   `3`
    ##   <chr>           <int> <int> <int>
    ## 1 Clouds/Mist        NA   247    NA
    ## 2 Good              463    NA    NA
    ## 3 Rain/Snow/Storm    NA    NA    21

## Months

``` r
bike <- bike %>%
  mutate(
    month_chr =
      case_when(
        mnth == 1 ~ "January",
        mnth == 2 ~ "February",
        mnth == 3 ~ "March",
        mnth == 4 ~ "April",
        mnth == 5 ~ "May",
        mnth == 6 ~ "June",
        mnth == 7 ~ "July",
        mnth == 8 ~ "August",
        mnth == 9 ~ "September",
        mnth == 10 ~ "October",
        mnth == 11 ~ "November",
        mnth == 12 ~ "December",
        TRUE ~ "other"
      )
  )

bike %>% 
  dplyr::count(mnth, month_chr) %>% 
  tidyr::spread(mnth, n)
```

    ## # A tibble: 12 x 13
    ##    month_chr   `1`   `2`   `3`   `4`   `5`   `6`   `7`   `8`   `9`  `10`
    ##    <chr>     <int> <int> <int> <int> <int> <int> <int> <int> <int> <int>
    ##  1 April        NA    NA    NA    60    NA    NA    NA    NA    NA    NA
    ##  2 August       NA    NA    NA    NA    NA    NA    NA    62    NA    NA
    ##  3 December     NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
    ##  4 February     NA    57    NA    NA    NA    NA    NA    NA    NA    NA
    ##  5 January      62    NA    NA    NA    NA    NA    NA    NA    NA    NA
    ##  6 July         NA    NA    NA    NA    NA    NA    62    NA    NA    NA
    ##  7 June         NA    NA    NA    NA    NA    60    NA    NA    NA    NA
    ##  8 March        NA    NA    62    NA    NA    NA    NA    NA    NA    NA
    ##  9 May          NA    NA    NA    NA    62    NA    NA    NA    NA    NA
    ## 10 November     NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
    ## 11 October      NA    NA    NA    NA    NA    NA    NA    NA    NA    62
    ## 12 September    NA    NA    NA    NA    NA    NA    NA    NA    60    NA
    ##     `11`  `12`
    ##    <int> <int>
    ##  1    NA    NA
    ##  2    NA    NA
    ##  3    NA    62
    ##  4    NA    NA
    ##  5    NA    NA
    ##  6    NA    NA
    ##  7    NA    NA
    ##  8    NA    NA
    ##  9    NA    NA
    ## 10    60    NA
    ## 11    NA    NA
    ## 12    NA    NA

## Years

``` r
bike <- bike %>%
  mutate(
    yr_ch =
      case_when(
        yr == 0 ~ "2011",
        yr == 1 ~ "2012",
        TRUE ~ "other"
      )
  )

bike %>% 
  dplyr::count(yr, yr_ch) %>% 
  tidyr::spread(yr, n)
```

    ## # A tibble: 2 x 3
    ##   yr_ch   `0`   `1`
    ##   <chr> <int> <int>
    ## 1 2011    365    NA
    ## 2 2012     NA   366

## Temperature

``` r
# normalize temperatures
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
```

## Date

``` r
# ~ convert to date ----
bike <- bike %>%
  mutate(dteday = as.Date(dteday))
```

-----

# Exploratory Data Analysis

Three options

## dplyr (\#1)

``` r
# create exploratory analysis table for continuous data
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
```

| var        |       min |        q25 |     median |        q75 |        max |       mean |          sd |
| :--------- | --------: | ---------: | ---------: | ---------: | ---------: | ---------: | ----------: |
| atemp      |  18.68837 |   27.48664 |   32.54892 |   36.69247 |   44.59046 |   32.12804 |    5.540680 |
| casual     |   2.00000 |  315.50000 |  713.00000 | 1096.00000 | 3410.00000 |  848.17647 |  686.622488 |
| cnt        |  22.00000 | 3152.00000 | 4548.00000 | 5956.00000 | 8714.00000 | 4504.34884 | 1937.211452 |
| hum        |   0.00000 |   52.00000 |   62.00000 |   73.00000 |   97.00000 |   62.30643 |   14.242776 |
| registered |  20.00000 | 2497.00000 | 3662.00000 | 4776.50000 | 6946.00000 | 3656.17237 | 1560.256377 |
| temp       | \-5.00000 |    7.00000 |   15.00000 |   22.00000 |   32.00000 |   14.79617 |    8.546779 |
| windspeed  |   1.00000 |    9.00000 |   12.00000 |   15.00000 |   34.00000 |   12.26265 |    5.190293 |

## skimr (\#2)

``` r
# skimr::skim() ----
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
```

| type      | variable        | missing | complete | min        | max        | mean    | sd      | median | hist     |
| :-------- | :-------------- | :------ | :------- | :--------- | :--------- | :------ | :------ | :----- | :------- |
| character | holiday\_chr    | 0       | 731      | 7          | 11         | NA      | NA      | NA     | NA       |
| character | month\_chr      | 0       | 731      | 3          | 9          | NA      | NA      | NA     | NA       |
| character | season\_chr     | 0       | 731      | 4          | 6          | NA      | NA      | NA     | NA       |
| character | weathersit\_chr | 0       | 731      | 4          | 15         | NA      | NA      | NA     | NA       |
| character | weekday\_chr    | 0       | 731      | 6          | 9          | NA      | NA      | NA     | NA       |
| character | workingday\_chr | 0       | 731      | 11         | 15         | NA      | NA      | NA     | NA       |
| character | yr\_ch          | 0       | 731      | 4          | 4          | NA      | NA      | NA     | NA       |
| Date      | dteday          | 0       | 731      | 2011-01-01 | 2012-12-31 | NA      | NA      | NA     | NA       |
| factor    | weekday\_fct    | 731     | 0        | NA         | NA         | NA      | NA      | NA     | NA       |
| integer   | casual          | 0       | 731      | NA         | NA         | 848.18  | 686.62  | 713    | ▇▇▅▂▁▁▁▁ |
| integer   | cnt             | 0       | 731      | NA         | NA         | 4504.35 | 1937.21 | 4548   | ▂▅▅▇▇▅▅▂ |
| integer   | holiday         | 0       | 731      | NA         | NA         | 0.029   | 0.17    | 0      | ▇▁▁▁▁▁▁▁ |
| integer   | hum             | 0       | 731      | NA         | NA         | 62.31   | 14.24   | 62     | ▁▁▁▃▇▇▅▂ |
| integer   | instant         | 0       | 731      | NA         | NA         | 366     | 211.17  | 366    | ▇▇▇▇▇▇▇▇ |
| integer   | mnth            | 0       | 731      | NA         | NA         | 6.52    | 3.45    | 7      | ▇▅▇▃▅▇▅▇ |
| integer   | registered      | 0       | 731      | NA         | NA         | 3656.17 | 1560.26 | 3662   | ▁▅▅▆▇▅▃▃ |
| integer   | season          | 0       | 731      | NA         | NA         | 2.5     | 1.11    | 3      | ▇▁▇▁▁▇▁▇ |
| integer   | temp            | 0       | 731      | NA         | NA         | 14.8    | 8.55    | 15     | ▁▅▇▇▆▆▇▂ |
| integer   | weathersit      | 0       | 731      | NA         | NA         | 1.4     | 0.54    | 1      | ▇▁▁▅▁▁▁▁ |
| integer   | weekday         | 0       | 731      | NA         | NA         | 3       | 2       | 3      | ▇▇▇▇▁▇▇▇ |
| integer   | windspeed       | 0       | 731      | NA         | NA         | 12.26   | 5.19    | 12     | ▂▇▇▆▂▁▁▁ |
| integer   | workingday      | 0       | 731      | NA         | NA         | 0.68    | 0.47    | 1      | ▃▁▁▁▁▁▁▇ |
| integer   | yr              | 0       | 731      | NA         | NA         | 0.5     | 0.5     | 1      | ▇▁▁▁▁▁▁▇ |
| numeric   | atemp           | 0       | 731      | NA         | NA         | 32.13   | 5.54    | 32.55  | ▁▅▇▇▇▇▆▁ |

## mosaic::inspect (\#3)

``` r
# mosaic::inspect -----------------------------------------------------
bike_inspect <- mosaic::inspect(bike)

# categorical
knitr::kable(bike_inspect$categorical)
```

| name            | class     | levels |   n | missing | distribution                        |
| :-------------- | :-------- | -----: | --: | ------: | :---------------------------------- |
| weekday\_chr    | character |      7 | 731 |       0 | Monday (14.4%), Saturday (14.4%) …  |
| weekday\_fct    | factor    |      7 |   0 |     731 | 0 (NaN%), 1 (NaN%), 2 (NaN%) …      |
| holiday\_chr    | character |      2 | 731 |       0 | Non-Holiday (97.1%), Holiday (2.9%) |
| workingday\_chr | character |      2 | 731 |       0 | Working Day (68.4%) …               |
| season\_chr     | character |      4 | 731 |       0 | Fall (25.7%), Summer (25.2%) …      |
| weathersit\_chr | character |      3 | 731 |       0 | Good (63.3%), Clouds/Mist (33.8%) … |
| month\_chr      | character |     12 | 731 |       0 | August (8.5%), December (8.5%) …    |
| yr\_ch          | character |      2 | 731 |       0 | 2012 (50.1%), 2011 (49.9%)          |

``` r
# categorical
knitr::kable(bike_inspect$Date)
```

| name   | class | first      | last       | min\_diff | max\_diff |   n | missing |
| :----- | :---- | :--------- | :--------- | :-------- | :-------- | --: | ------: |
| dteday | Date  | 2011-01-01 | 2012-12-31 | 1 days    | 1 days    | 731 |       0 |

``` r
# categorical
knitr::kable(bike_inspect$quantitative)
```

| name       | class   |       min |         Q1 |     median |         Q3 |        max |         mean |           sd |   n | missing |
| :--------- | :------ | --------: | ---------: | ---------: | ---------: | ---------: | -----------: | -----------: | --: | ------: |
| instant    | integer |   1.00000 |  183.50000 |  366.00000 |  548.50000 |  731.00000 |  366.0000000 |  211.1658116 | 731 |       0 |
| season     | integer |   1.00000 |    2.00000 |    3.00000 |    3.00000 |    4.00000 |    2.4965800 |    1.1108071 | 731 |       0 |
| yr         | integer |   0.00000 |    0.00000 |    1.00000 |    1.00000 |    1.00000 |    0.5006840 |    0.5003419 | 731 |       0 |
| mnth       | integer |   1.00000 |    4.00000 |    7.00000 |   10.00000 |   12.00000 |    6.5198358 |    3.4519128 | 731 |       0 |
| holiday    | integer |   0.00000 |    0.00000 |    0.00000 |    0.00000 |    1.00000 |    0.0287278 |    0.1671547 | 731 |       0 |
| weekday    | integer |   0.00000 |    1.00000 |    3.00000 |    5.00000 |    6.00000 |    2.9972640 |    2.0047869 | 731 |       0 |
| workingday | integer |   0.00000 |    0.00000 |    1.00000 |    1.00000 |    1.00000 |    0.6839945 |    0.4652334 | 731 |       0 |
| weathersit | integer |   1.00000 |    1.00000 |    1.00000 |    2.00000 |    3.00000 |    1.3953488 |    0.5448943 | 731 |       0 |
| temp       | integer | \-5.00000 |    7.00000 |   15.00000 |   22.00000 |   32.00000 |   14.7961696 |    8.5467794 | 731 |       0 |
| atemp      | numeric |  18.68837 |   27.48664 |   32.54892 |   36.69247 |   44.59046 |   32.1280356 |    5.5406801 | 731 |       0 |
| hum        | integer |   0.00000 |   52.00000 |   62.00000 |   73.00000 |   97.00000 |   62.3064295 |   14.2427756 | 731 |       0 |
| windspeed  | integer |   1.00000 |    9.00000 |   12.00000 |   15.00000 |   34.00000 |   12.2626539 |    5.1902926 | 731 |       0 |
| casual     | integer |   2.00000 |  315.50000 |  713.00000 | 1096.00000 | 3410.00000 |  848.1764706 |  686.6224883 | 731 |       0 |
| registered | integer |  20.00000 | 2497.00000 | 3662.00000 | 4776.50000 | 6946.00000 | 3656.1723666 | 1560.2563770 | 731 |       0 |
| cnt        | integer |  22.00000 | 3152.00000 | 4548.00000 | 5956.00000 | 8714.00000 | 4504.3488372 | 1937.2114516 | 731 |       0 |
