#=====================================================================#
# This is code to create: import
# Authored by and feedback to:
# MIT License
# Version:
#=====================================================================#


# packages ----------------------------------------------------------------

library(magrittr) # Pipes %>%, %T>% and equals(), extract().
library(tidyverse) # all tidyverse packages
library(fs) # file management functions
library(fivethirtyeight)
library(mdsr) # modern data science with R
library(broom) # tidying models
library(modelr) # modelr package
library(ggrepel) # repel text overlay in graphs
library(gridExtra) # arrange multiple plots
library(grid) # text for graph title
library(egg) # for ggarrange
library(corrr) # correlations
# devtools::install_github("ropensci/skimr", ref = "v2")
library(skimr)

# download key and peele
utils::download.file(
  url =
    "https://raw.githubusercontent.com/richardcornish/sketch-comedy-data/master/csvs/amy.csv",
  destfile = paste0(
    "data/",
    base::noquote(lubridate::today()),
    "raw-amy-schumer.csv"
  )
)
# download amy schumer
utils::download.file(
  url =
    "https://raw.githubusercontent.com/richardcornish/sketch-comedy-data/master/csvs/kap.csv",
  destfile = paste0(
    "data/",
    base::noquote(lubridate::today()),
    "raw-key-and-peele.csv"
  )
)

# import raw .csvs
AmySchumerRaw <- readr::read_csv(paste0(
  "data/",
  base::noquote(lubridate::today()),
  "raw-amy-schumer.csv"
))

KeyAndPeeleRaw <- readr::read_csv(paste0(
  "data/",
  base::noquote(lubridate::today()),
  "raw-key-and-peele.csv"
))


# create simulated data  --------------------------------------------------
# from this post
# https://www.r-bloggers.com/simulating-random-multivariate-correlated-data-continuous-variables/
# 
R <- matrix(cbind(1,.80,.2,  
                  .80,1,.7,  
                  .2,.7, 1), nrow = 3)
U <- t(chol(R))
# number of variables 
nvars <- dim(U)[1]
# create the number of observations
numobs <- 100000
# set random seed
set.seed(20)

random.normal <- matrix(data = rnorm(nvars * numobs, 2, 4), 
                        nrow = nvars, 
                        ncol = numobs)
# create X 
X <- U %*% 
    random.normal
# t distribution
newX <- t(X)

# put in data frame
raw <- as.data.frame(newX)

orig.raw <- as.data.frame(t(random.normal))

names(raw) <- c("outcome", "predictor_1", "predictor_2")

SimDat <- raw %>% 
    dplyr::sample_n(size = 10000) %>% 
    dplyr::mutate(predictor_2 = abs(predictor_2*2))
    
# remove all previous junk
rm(R, U, nvars, numobs, random.normal, X, newX, raw, orig.raw)

# cor(raw)
# cor(orig.raw)

