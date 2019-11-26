#=====================================================================#
# This is code to create: 34.0-animate-norm-vars.R
# Authored by and feedback to: mjfrigaard@gmail.com
# MIT License
# Version: 1.0
# Share: http://bit.ly/gganimate-gif
#=====================================================================#

library(ggplot2)
library(gganimate)
library(gifski)
# create data
NormalData <- tibble(random_var_x = c(stats::rnorm(n = 1000, 
                                                   mean = 10, 
                                                   sd = 1), 
                                      stats::rnorm(n = 1000,
                                                   mean = 10, 
                                                   sd = 5),
                                       stats::rnorm(n = 1000,
                                                    mean = 10, 
                                                    sd = 20),
                                       stats::rnorm(n = 1000,
                                                    mean = 10, 
                                                    sd = 50)),
  group_factor = gl(n = 4, k = 1000, label = c("Mean = 10, SD = 1",
                                                "Mean = 10, SD = 5",
                                                "Mean = 10, SD = 20",
                                                "Mean = 10, SD = 50")))
# NormalData
# create static plot
norm_plot <- ggplot2::ggplot(NormalData, aes(x = random_var_x, 
                                    fill = group_factor,
                                    color = group_factor,
                                    group = 1L)) + 
      ggplot2::geom_histogram(bins = 150) + 
      gganimate::transition_states(states = group_factor,
                    transition_length = 2,
                    state_length = 1) + 
                    ease_aes('cubic-in-out') + 
      gganimate::shadow_mark() +
      ggplot2::labs(title = "Means & Standard Deviations from\n Normally Generated Variables",
                    subtitle = "Number {frame} of {nframes}",
                    x = "Random Variable X",
                    y = "Count",
                    color = "Group factor",
                    fill = "Group factor")
# norm_plot
# animate
norm_animate <- gganimate::animate(norm_plot, nframes = 100, 
                   res = 150, 
                   height = 7, 
                   width = 9, 
                   units = "in")
norm_animate

# Save the output
anim_save(filename = 'normal-samples.gif',
          animation = norm_plot, 
          path = "figs/")
