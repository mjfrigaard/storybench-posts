Bike rentals - modeling with GBM
================

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

Run previous scripts to import and wrangle data.

``` r
# fs::dir_ls("code")
base::source("code/01-import.R")
base::source("code/02-wrangle.R")
```

Now check for the data in our working environment.

``` r
BikeData %>% glimpse()
```
