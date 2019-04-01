library(tidyverse)
library(caret)
library(ggplot2)
library(gbm)
library(caret)
library(hydroGOF)
library(Metrics)
library(scales)

# ames housing example
ames_split <- initial_split(AmesHousing::make_ames(), prop = .7)
ames_train <- training(ames_split)
ames_test  <- testing(ames_split)

# convert to matrix
#model
fit1 <- gbm(Sale_Price ~., data = ames_train, verbose = TRUE, shrinkage = 0.01, interaction.depth = 3, n.minobsinnode = 5,
            n.trees = 5000, cv.folds = 10)

perf.gbm1 <- gbm.perf(fit1)

prediction1 <- predict(fit1, newdata = ames_test, n.trees=perf.gbm1)

rmse.fit1 <- rmse(ames_test$Sale_Price, prediction1)

print(rmse.fit1)

#plot
effects <- data.frame(summary(fit1))
effects$Relative_Inlfuence <- effects$rel.inf

plot.gbm(fit1, i.var = c(8,1))
plot.gbm(fit1, i.var = 1)
plot.gbm(fit1, i.var = 2)
plot.gbm(fit1, i.var = 46)
plot.gbm(fit1, i.var = c(50, 46))


# Predicted v actual
ames_test$predicted <- as.integer(predict(fit1, newdata = ames_test, n.trees=perf.gbm1))

# plot predicted v actual
ggplot(ames_test) +
  geom_point(aes(y=predicted,x=Sale_Price, color=predicted-Sale_Price),alpha=0.7) +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) + 
  scale_x_continuous(labels = comma) +
  scale_y_continuous(labels = comma) +
  scale_color_continuous(name = "Predicted - Actual", labels = comma) +
  ylab('Predicted') +
  xlab('Actual') +
  ggtitle('Predicted vs Actual Sale Price') 


effects %>% 
  dplyr::arrange(desc(rel.inf)) %>%
  dplyr::top_n(25) %>%
  ggplot(aes(reorder(var, Relative_Inlfuence), Relative_Inlfuence, fill = Relative_Inlfuence)) +
  geom_col() +
  coord_flip() +
  scale_color_brewer(palette="Dark2") +
  theme_fivethirtyeight() +
  theme(axis.title = element_text()) + 
  xlab('Features')+
  ylab('Relative Influence') +
  ggtitle("Top 25 Drivers of Home Price")





