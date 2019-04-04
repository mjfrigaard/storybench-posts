library(rsample)      
library(caret)        
library(ggthemes)
library(scales)
library(wesanderson)
library(tidyr)
library(ggplot2)
library(gbm)
library(Metrics)
library(dplyr)


# read data of bike rentals daily ----
bike <- read.csv("day.csv") 

# recode with labels and make factor
bike <- bike %>% 
  mutate(weekday_ch = 
      case_when(
      weekday == 0 ~ "Sunday",
      weekday == 1 ~ "Monday",
      weekday == 2 ~ "Tuesday",
     weekday == 3 ~ "Wednesday",
     weekday == 4 ~ "Thursday",
     weekday == 5 ~ "Friday",
     weekday == 6 ~ "Saturday",
     TRUE ~ "other"))

bike <- bike %>% 
  mutate(holiday_ch =
           case_when(
             holiday == 0 ~ "Non-Holiday",
             holiday == 1 ~ "Holiday",
             TRUE ~ "other"
           ))

bike <- bike %>% 
  mutate(workingday_ch =
           case_when(
             workingday == 0 ~ "Non-Working Day",
             workingday == 1 ~ "Working Day",
             TRUE ~ "other"
           ))

bike <- bike %>% 
  mutate(season_ch =
           case_when(
             season == 1 ~ "Spring",
             season == 2 ~ "Summer",
             season == 3 ~ "Fall",
             season == 4 ~ "Winter",
             TRUE ~ "other"
           ))

bike <- bike %>% 
  mutate(weathersit_ch =
           case_when(
             weathersit == 1 ~ "Good",
             weathersit == 2 ~ "Clouds/Mist",
             weathersit == 3 ~ "Rain/Snow/Storm",
             TRUE ~ "other"
           ))

bike <- bike %>% 
  mutate(mnth_ch =
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
            ))

bike <- bike %>% 
  mutate(yr_ch =
           case_when(
             yr == 0 ~ "2011",
             yr == 1 ~ "2012",
             TRUE ~ "other"
           ))

# normalize temperatures
bike <- bike %>% 
  mutate(temp = as.integer(temp * (39 - (-8)) + (-8)))

bike <- bike %>% 
  mutate(atemp = atemp * (50 - (16)) + (16))

# windspeed ----
bike <- bike %>% 
  mutate(windspeed = as.integer(67 * bike$windspeed))

# humidity ----
bike <- bike %>% 
  mutate(hum = as.integer(100 * bike$hum))

# convert to date ----
bike <- bike %>%
  mutate(dteday = as.Date(dteday))


# select variables for model
bike2 <- bike %>% select( cnt,
                season,
                yr,
                mnth,
                holiday,
                weekday,
                workingday,
                weathersit,
                temp,
                atemp,
                hum,
                windspeed
                )

# gbm
bike_split <- initial_split(bike2, prop = .7)
bike_train <- training(bike_split)
bike_test  <- testing(bike_split)



#model
fit1 <- gbm(cnt ~., data = bike_train, 
            verbose = TRUE, 
            shrinkage = 0.01, 
            interaction.depth = 3, 
            n.minobsinnode = 5,
            n.trees = 5000, 
            cv.folds = 10
            )

# model performance
perf.gbm1 <- gbm.perf(fit1)

prediction1 <- predict(fit1, newdata = bike_test, n.trees=perf.gbm1)

rmse.fit1 <- rmse(bike_test$cnt, prediction1)
print(rmse.fit1)

# model info
getModelInfo()$gbm$parameters


#plot
effects <- data.frame(summary(fit1))
effects$Relative_Inlfuence <- effects$rel.inf

plot.gbm(fit1, i.var = 8)
plot.gbm(fit1, i.var = 9)
plot.gbm(fit1, i.var = 10)
plot.gbm(fit1, i.var = 11)

plot.gbm(fit1, i.var = c(5, 11))
plot.gbm(fit1, i.var = c(5, 8))


# Predicted v actual
bike_test$predicted <- as.integer(predict(fit1, newdata = bike_test, n.trees=perf.gbm1))

# plot predicted v actual
ggplot(bike_test) +
  geom_point(aes(y=predicted,x=cnt, color=predicted-cnt),alpha=0.7) +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) + 
  scale_x_continuous(labels = comma) +
  scale_y_continuous(labels = comma) +
  scale_color_continuous(name = "Predicted - Actual", labels = comma) +
  ylab('Predicted Bike Rentals') +
  xlab('Actual Bike Rentals') +
  ggtitle('Predicted vs Actual Bike Rentals') 


effects %>% 
  dplyr::arrange(desc(rel.inf)) %>%
  dplyr::top_n(10) %>%
  ggplot(aes(reorder(var, Relative_Inlfuence), Relative_Inlfuence, fill = Relative_Inlfuence)) +
  geom_col() +
  coord_flip() +
  scale_color_brewer(palette="Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) + 
  xlab('Features')+
  ylab('Relative Influence') +
  ggtitle("Top 10 Drivers of Bike Rentals")



# moodel 2
# select variables for model
bike3 <- bike %>% select( cnt,
                          season,
                          yr,
                          mnth,
                          holiday,
                          weekday,
                          workingday,
                          weathersit,
                          temp,
                          atemp,
                          hum,
                          windspeed
)

# convert to factors
bike3$weekday <- as.factor(bike3$weekday)
bike3$season<- as.factor(bike3$season)
bike3$mnth <- as.factor(bike3$mnth)
bike3$yr <- as.factor(bike3$yr)
bike3$holiday <- as.factor(bike3$holiday)
bike3$weathersit <- as.factor(bike3$weathersit)




# gbm
bike_split2 <- initial_split(bike3, prop = .7)
bike_train2 <- training(bike_split2)
bike_test2  <- testing(bike_split2)



#model
fit2 <- gbm(cnt ~., data = bike_train2, 
            verbose = TRUE, 
            shrinkage = 0.01, 
            interaction.depth = 3, 
            n.minobsinnode = 5,
            n.trees = 5000, 
            cv.folds = 10
)


# model2 performance
perf.gbm2 <- gbm.perf(fit2)

prediction2 <- predict(fit2, newdata = bike_test2, n.trees=perf.gbm1)

rmse.fit2 <- rmse(bike_test2$cnt, prediction2)
print(rmse.fit2)

summary(fit2)












# Create training (70%) and test (30%) sets for the  data.
# Use set.seed for reproducibility
set.seed(123)
bike_split <- initial_split(bike, prop = .7)
bike_train <- training(bike_split)
bike_test  <- testing(bike_split)

# for reproduciblity
set.seed(123)

# default RF model
m1 <- randomForest(
  formula = cnt ~ .,
  data    = bike
)

m1

# plot trees error
plot(m1)

# number of trees with lowest MSE
which.min(m1$mse)
# [1] 443

# RMSE of this optimal random forest
sqrt(m1$mse[which.min(m1$mse)])
## [1] 668.743

# create training and validation data 
set.seed(123)
valid_split <- initial_split(bike, .8)

# training data
bike_v2 <- analysis(valid_split)

# validation data
bike_valid <- assessment(valid_split)
x_test <- bike_valid[setdiff(names(bike_valid), "cnt")]
y_test <- bike_valid$cnt

rf_oob_comp <- randomForest(
  formula = cnt ~ .,
  data    = bike_v2,
  xtest   = x_test,
  ytest   = y_test
)

# extract OOB & validation errors
oob <- sqrt(rf_oob_comp$mse)
validation <- sqrt(rf_oob_comp$test$mse)

# compare error rates
tibble::tibble(
  `Out of Bag Error` = oob,
  `Test error` = validation,
  ntrees = 1:rf_oob_comp$ntree
) %>%
  gather(Metric, RMSE, -ntrees) %>%
  ggplot(aes(ntrees, RMSE, color = Metric)) +
  geom_line() +
  scale_y_continuous() +
  xlab("Number of trees")

# names of features
features <- setdiff(names(bike_train), "cnt")

set.seed(123)

m2 <- tuneRF(
  x          = bike_train[features],
  y          = bike_train$cnt,
  ntreeTry   = 500,
  mtryStart  = 5,
  stepFactor = 1.5,
  improve    = 0.01,
  trace      = FALSE      # to not show real-time progress 
)


# hyperparameter grid search
hyper_grid <- expand.grid(
  mtry       = seq(2, 9, by = 2),
  node_size  = seq(3, 9, by = 2),
  sampe_size = c(.55, .632, .70, .80),
  OOB_RMSE   = 0
)

# total number of combinations
nrow(hyper_grid)

for(i in 1:nrow(hyper_grid)) {
  
  # train model
  model <- ranger(
    formula         = cnt ~ ., 
    data            = bike_train, 
    num.trees       = 500,
    mtry            = hyper_grid$mtry[i],
    min.node.size   = hyper_grid$node_size[i],
    sample.fraction = hyper_grid$sampe_size[i],
    seed            = 123
  )
  
  # add OOB error to grid
  hyper_grid$OOB_RMSE[i] <- sqrt(model$prediction.error)
}

hyper_grid %>% 
  dplyr::arrange(OOB_RMSE) %>%
  head(10)

OOB_RMSE <- vector(mode = "numeric", length = 100)

for(i in seq_along(OOB_RMSE)) {
  
  optimal_ranger <- ranger(
    formula         = cnt ~ ., 
    data            = bike_train, 
    num.trees       = 443,
    mtry            = 7,
    min.node.size   = 3,
    sample.fraction = .8,
    importance      = 'impurity'
  )
  
  OOB_RMSE[i] <- sqrt(optimal_ranger$prediction.error)
}

hist(OOB_RMSE, breaks = 20)

optimal_ranger$variable.importance %>% 
  tidy() %>%
  dplyr::arrange(desc(x)) %>%
  dplyr::top_n() %>%
  ggplot(aes(reorder(names, x), x)) +
  geom_col() +
  coord_flip() +
  ggtitle("Top 5 important variables")


varImpPlot(m1, main='Variable Importance Plot: Final Model',pch=16,col='blue')

pred <- predict(object=m1,newdata=bike_test)
actual<-bike_test$cnt
result<-data.frame(actual=actual,predicted=pred)
paste('Function Call: ', m1$call)
paste('Root Mean Squared error: ',mean(sqrt(m1$mse)))


ggplot(result)+
  geom_point(aes(x=actual,y=predicted,color=predicted-actual),alpha=0.7) +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) + 
  ylab('Predicted') +
  xlab('Actual') +
  ggtitle("Model Error: 
Predicted Rentals - Actual Rentals")  
  
m1$variable.importance %>% 
  tidy() %>%
  dplyr::arrange(desc(x)) %>%
  dplyr::top_n(5) %>%
  ggplot(aes(reorder(names, x), x)) +
  geom_col() +
  coord_flip() +
  ggtitle("Top 5 important variables")




# ames housing example
ames_split <- initial_split(AmesHousing::make_ames(), prop = .7)
ames_train <- training(ames_split)
ames_test  <- testing(ames_split)
OOB_RMSE <- vector(mode = "numeric", length = 100)
predictions <- optimal_ranger$predictions
actual <- ames_train$Sale_Price

data1 <- data.frame(rbind(predictions, actual))

for(i in seq_along(OOB_RMSE)) {
  
  optimal_ranger <- ranger(
    formula         = Sale_Price ~ ., 
    data            = ames_train, 
    num.trees       = 500,
    mtry            = 24,
    min.node.size   = 5,
    sample.fraction = .8,
    importance      = 'impurity'
  )
  
  OOB_RMSE[i] <- sqrt(optimal_ranger$prediction.error)
}

hist(OOB_RMSE, breaks = 20)

optimal_ranger$variable.importance %>% 
  tidy() %>%
  dplyr::arrange(desc(x)) %>%
  dplyr::top_n(25) %>%
  ggplot(aes(reorder(names, x), x)) +
  geom_col() +
  coord_flip() +
  ggtitle("Top 25 important variables")





