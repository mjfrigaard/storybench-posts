#=====================================================================#
# This is code to create: corrr overview
# Authored by and feedback to:
# MIT License
# Version: 1.0
#=====================================================================#

# ‹(•_•)› PACKAGES ––•––•––√\/––√\/––•––•––√\/––√\/––•––•––√\/––√\/  ----
#                   _
#                  | |
#  _ __   __ _  ___| | ____ _  __ _  ___  ___
# | '_ \ / _` |/ __| |/ / _` |/ _` |/ _ \/ __|
# | |_) | (_| | (__|   < (_| | (_| |  __/\__ \
# | .__/ \__,_|\___|_|\_\__,_|\__, |\___||___/
# | |                          __/ |
# |_|                         |___/


# sample data -------------------------------------------------------------

d <- mtcars
d$hp[3] <- NA
head(d)

# We could be motivated by multicollinearity:

fit_1 <- lm(mpg ~ hp,        data = d)
fit_2 <- lm(mpg ~ hp + disp, data = d)

summary(fit_1)
summary(fit_2)

# check the correlations with cor

rs <- cor(d)
rs

# use pairwise complete to handle missing values with use:

rs <- cor(d, use = "pairwise.complete.obs")
rs

# remember that this is a matrix
class(rs)

library(corrr)
d %>%
  correlate()
  focus(mpg:drat, mirror = TRUE) %>%
  network_plot()