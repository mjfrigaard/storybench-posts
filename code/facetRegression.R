# I would like to annotate ggplot2 with a regression equation and r squared.
# Ideally, it would work for facets and the location of the annotation could be
# conveniently specified (e.g. "topleft"). Maybe it’s just my ignorance but
# there seems to be no specific function in ggplot2 package to achieve this.
# This is surprising to me because displaying r squared, slope and intercept
# in the plot is quite common and informative. Having the option to display
# model coefficients and R2 as plot annotation would be a great extension
# of geom_smooth() or stat_smooth() functions, even if it worked for lm
# method only.

# I found the following answers to a similar question on Stack Overflow and
# RPubs, but the solutions are not so straightforward (problems with facets,
# positioning).

# https://stackoverflow.com/questions/7549694/adding-regression-line-equation-and-r2-on-graph 1.2k
# https://rstudio-pubs-static.s3.amazonaws.com/213536_d4b3975ee92b43af8671057ccefb90c7.html 588
#
# Do you guys have any recommendations of how to add model information to the
# plot?
#
# Many thanks!



# https://community.rstudio.com/t/annotate-ggplot2-with-regression-equation-and-r-squared/6112/10

require(tidyverse)

facetRegression <- function(dat, xvar, yvar, group) {
    # combine the inputs into linear regression syntax
  fml <- paste(yvar, "~", xvar)

  group <- rlang::sym(group)
  # 
  wrap_fml <- rlang::new_formula(rhs = group, lhs = NULL)
  # 
  dot <- rlang::quo(-!!group)
  # 

  dat %>%
      # 
    nest(!!dot) %>%
      # 
    mutate(
      model = purrr::map(data, ~ lm(fml, data = .x)),
      # 
      adj.r.squared = purrr::map_dbl(model, ~ signif(summary(.x)$adj.r.squared, 5)),
      # 
      intercept = purrr::map_dbl(model, ~ signif(.x$coef[[1]], 5)),
      # 
      slope = purrr::map_dbl(model, ~ signif(.x$coef[[2]], 5)),
      # 
      pvalue = purrr::map_dbl(model, ~ signif(summary(.x)$coef[2, 4], 5))
    ) %>%
      # 
    select(-data, -model) %>%
      # 
    left_join(dat) %>%
      # 
    ggplot(aes_string(xvar, yvar)) +
      # 
    geom_point() +
      # 
    geom_smooth(se = FALSE, 
                method = "lm") +
      # 
    facet_wrap(wrap_fml) +
      # 
    geom_text(aes(x = 3, # this needs to be adjusted to a constant
                  
                  y = 25, # this is a value that needs to be a constant
                  
                  label = paste("Adj R2 = ", adj.r.squared, "\n",
                                "Intercept =", intercept, "\n",
                                "Slope =", slope, "\n",
                                "P =", pvalue
    )))
}
# test
facetRegression(dat = mpg, 
                xvar = "displ", 
                yvar = "hwy", 
                group = "class")
