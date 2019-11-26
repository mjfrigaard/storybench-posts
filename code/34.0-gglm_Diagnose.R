#=====================================================================#
# This is code to create: 34.0-gglm_Diagnose.R
# Authored by and feedback to: mjfrigaard@gmail.com
# MIT License
# Version: 1.0
# Share: http://bit.ly/gglm_Diagnose
#=====================================================================#
require(ggplot2)
require(gridExtra)
require(hrbrthemes)
require(ggrepel)

ggplot2::theme_set(theme_ipsum_tw(
  base_size = 9,
  strip_text_size = 9,
  axis_title_size = 11,
  plot_title_size = 17,
  subtitle_size = 13,
  base_family = "Ubuntu",
  # "JosefinSans-LightItalic"
  strip_text_family = "TitilliumWeb-Regular",
  axis_title_family = "TitilliumWeb-Regular",
  subtitle_family = "TitilliumWeb-Regular",
  plot_title_family = "JosefinSans-Regular"
))

# Function requirements
# =======================
# Assuming a linear regression model created with:
#   model <- lm(outcome ~ predictor, data = data)
# This function will create plots similar to:
#   plot(model)
# 
# The . prefix variables:
# =======================
# ggplot2 has a fortify() function that can create the following variables
#
#       .hat - Diagonal of the hat matrix
#       .sigma - Estimate of residual standard deviation when corresponding 
#               observation is dropped from model
#       .cooksd - Cooks distance, cooks.distance()
#       .fitted - Fitted values of model
#       .resid - Residuals
#       .stdresid - Standardised residuals
#  Read more: https://ggplot2.tidyverse.org/reference/fortify.lm.html

gglm_Diagnose <- function(model_object) {
# create model params data frame
modelparams <- ggplot2::fortify(model_object) %>% 
    tibble::as_tibble()
# get top leverage points
std_res <- rstandard(model_object)
leverage <- hatvalues(model_object)
# put in tibble
LevStdRes <- tibble::tibble(`Leverage` = leverage,
               `Standardized Residuals` = std_res)
# top 5 tibble
Top5LevStdRes <- LevStdRes %>% 
    dplyr::arrange(desc(`Leverage`)) %>% 
    utils::head(5)
# Top5LevStdRes

# create data for labels
ResidVsLevData <- modelparams %>% 
        dplyr::mutate(index_cooksd = seq_along(.cooksd)) %>% 
        dplyr::arrange(desc(.cooksd)) %>% 
        head(5)

# ResidVsLevData
# create model object
model <- model_object

# Residual Vs. Fitted -----------------------------------------------------
ggplot(data = model, 
       mapping = aes(x = .fitted, 
                     y = .resid)) +
    ggplot2::geom_point() + 
      stat_smooth(method = "loess", 
                  color = "darkblue") +
    ggplot2::geom_hline(
      yintercept = 0,
      col = "darkred",
      linetype = "dashed") + 
      ggplot2::labs(x = "Fitted values",
                    y = "Residuals",
                    title = "Residual vs Fitted Plot") -> ggResidVsFit
ggResidVsFit

# Normal Q-Q --------------------------------------------------------------
ggplot(data = model, aes(sample =  model$model[1][[1]])) +
    ggplot2::stat_qq() + 
    ggplot2::stat_qq_line() + 
    ggplot2::labs(x = "Theoretical Quantiles",
                      y = "Standardized Residuals",
                  title = "Normal Q-Q") -> ggNormQQPlot
ggNormQQPlot

# Scale-Location ----------------------------------------------------------
ggplot2::ggplot(data = model, aes(
    x = .fitted,
    y = sqrt(abs(.stdresid))
  )) +
ggplot2::geom_point(na.rm = TRUE) + 
    stat_smooth(
    method = "loess",
    color = "darkblue",
    na.rm = TRUE
  ) +
ggplot2::labs(x = "Fitted Value",
    y = expression(sqrt("|Standardized residuals|")), 
    title = "Scale-Location") -> ggScaleLocation
  
ggScaleLocation


# Cook's Distance ---------------------------------------------------------
ggplot2::ggplot(data = model,
                    # this goes on the x axis 
        mapping = aes(x = seq_along(.cooksd),
                      # Cook's D goes on the y
                       y = .cooksd, 
                      # the minimum is always 0
                       ymin = 0, 
                      # the max is the max value for .cooksd
                       ymax = .cooksd)) +
        # add the points with a size 0.8
        ggplot2::geom_point(size = 1.7,
                            alpha = 4/5) +
        # and the linegrange goes from the 0 on the y, to the point
        # on the y axis 
        ggplot2::geom_linerange(size = 0.3, 
                                alpha = 2/3) +
    
        # set the ylim (y limits) for 0 and the max value for the .cooksd
        ggplot2::ylim(0, 
                      max(ResidVsLevData$.cooksd, na.rm = TRUE)) +
        # the labs are added last
        ggplot2::labs(x = "Observation Number", 
                      y = "Cook's distance", 
                      title = "Cook's Distance")  -> ggCooksDistance
ggCooksDistance

# Residual vs Leverage Plot -----------------------------------------------

ggplot2::ggplot(data = model, 
       aes(x = .hat, 
           y = .stdresid)) + 
    
    ggplot2::geom_point() + 
    
    ggplot2::stat_smooth(method = "loess",
                color = "darkblue",
                na.rm = TRUE) +
    
    ggrepel::geom_label_repel(data = Top5LevStdRes, 
                      mapping = aes(x = Top5LevStdRes$Leverage,
                            y = Top5LevStdRes$`Standardized Residuals`,
                                    label = Top5LevStdRes$Leverage),
                              label.size = 0.15) + 
    
    ggplot2::geom_point(data = Top5LevStdRes, 
                        mapping = aes(x = Top5LevStdRes$Leverage,
                            y = Top5LevStdRes$`Standardized Residuals`),
                        show.legend = FALSE) + 
    
    ggplot2::labs(x = "Leverage", 
                  y = "Standardized Residuals",
                  title = "Residual vs Leverage Plot") + 
    
    scale_size_continuous("Cook's Distance", range = c(1,5)) +
    
    theme(legend.position = "bottom") -> ggResidLevPlot

ggResidLevPlot

# combine the plots into a list
  return(list("Residual vs Fitted Plot" = ggResidVsFit, 
              "Normal Q-Q" = ggNormQQPlot, 
              "Scale-Location" = ggScaleLocation, 
              "Cooks Distance" = ggCooksDistance,
              "Residual vs Leverage Plot" = ggResidLevPlot))

}

# test models ------------------------------------------------------------
# lmmpg <- lm(hwy ~ cyl + displ + trans, data = mpg)
# lmmtcars <- lm(mpg ~ cyl + disp + hp, data = mtcars)
# plots <- gglm_Diagnose(lmmpg)
# plots2 <- gglm_Diagnose(lmmtcars)
# plots2


# compare -----------------------------------------------------------------
# plot(lmmpg)

