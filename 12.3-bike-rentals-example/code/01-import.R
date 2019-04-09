#=====================================================================#
# This is code to create: import daily bike share data
# Authored by and feedback to mjfrigaard@gmail.com
# MIT License
# Version: 1.0
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

# read data of bike rentals daily ----
bike <- read.csv("data/day.csv")
