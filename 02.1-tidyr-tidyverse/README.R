## ----setup, include=FALSE------------------------------------------------
library(tidyverse)
library(magrittr)
if (!file.exists("images/")) {
  dir.create("images/")
}
knitr::opts_chunk$set(
  echo = TRUE, # show all code
  tidy = FALSE, # cleaner code printing
  eval = TRUE,
  size = "small", # smaller code
  fig.path = "images/"
)
knitr::opts_knit$set(width = 75)
options(
  tibble.print_max = 14,
  max.print = "75"
)


## ----packages, eval=TRUE, warning=FALSE, message=FALSE-------------------
# this will require the newest version of tidyr from github
# devtools::install_github("tidyverse/tidyr")
library(tidyverse)
library(here)


## ----load-data, message=FALSE, warning=FALSE-----------------------------
source("code/data.R")
base::save.image("data/tidyr-data.RData")
base::load(file = "data/tidyr-data.RData")


## ----Indexed, echo=FALSE-------------------------------------------------
Indexed


## ----Cartesian, echo=FALSE-----------------------------------------------
Cartesian


## ----table-intersection.png, echo=FALSE, eval=TRUE-----------------------
# fs::dir_ls("images")
knitr::include_graphics(
  path = "images/indexed-carteisan.png")


## ----DataTibble, echo=FALSE----------------------------------------------
DataTibble


## ----group-by------------------------------------------------------------
DataTibble %>%
  dplyr::group_by(group_var)


## ----summarize-----------------------------------------------------------
DataTibble %>%
  dplyr::group_by(group_var) %>%
  dplyr::summarize(
    x_mean = mean(x_measurement),
    y_mean = mean(y_measurement),
    no = n()
  )


## ----count---------------------------------------------------------------
DataTibble %>%
  dplyr::count(group_var, ordinal_y_var)


## ----spread--------------------------------------------------------------
DataTibble %>%
  dplyr::count(group_var,ordinal_y_var) %>%
  tidyr::spread(key = group_var,value = n)


## ----spread-and-gather---------------------------------------------------
DataTibble %>%
  dplyr::count(group_var, ordinal_y_var) %>%
  tidyr::spread(key = group_var, value = n) %>%
  tidyr::gather(key = group_var, value = "n", 
                -ordinal_y_var, na.rm = TRUE) %>%
  dplyr::select(group_var, ordinal_y_var, n)


## ----images/loma-pivot.gif, echo=FALSE, eval=TRUE, fig.cap="'I think footwork is one of the most important things to becoming a great fighter. That's where everything starts.' - Vasyl Lomachenko"----
knitr::include_graphics(path = "images/loma-pivot.gif")


## ----pivot-longer-image, echo=FALSE, eval=TRUE---------------------------
knitr::include_graphics(path = "images/pivot-longer-image.png")


## ----pivot-wider-image, echo=FALSE, eval=TRUE----------------------------
knitr::include_graphics(path = "images/pivot-wider-image.png")


## ----LomaWideSmall, echo=TRUE, message=FALSE, warning=FALSE--------------
LomaWideSmall %>% utils::head()


## ----pivot-longer--------------------------------------------------------
LomaWideSmall %>%
    
  tidyr::pivot_longer(
      
    cols = starts_with("fight"),

    names_to = "fight_no",

    values_to = "result",

    names_prefix = "fight_",

    na.rm = TRUE)


## ----tidy-pivoting-longer, eval=TRUE, echo=FALSE-------------------------
knitr::include_graphics(path = "images/tidy-pivoting-longer.png")


## ----create-LomaSpec-----------------------------------------------------
LomaSpec <- LomaWideSmall %>%
    
  tidyr::pivot_longer_spec(
      
    cols = starts_with("fight"),

    names_to = "fight_no",

    values_to = "result",

    names_prefix = "fight_")

LomaSpec


## ----mutate-LomaSpec-----------------------------------------------------
# format the variable
LomaSpec <- LomaSpec %>%
    
  dplyr::mutate(fight_no = as.numeric(fight_no))

LomaSpec$fight_no %>% glimpse(78)


## ----supply-LomaSpec-----------------------------------------------------
# supply it to the pivot_longer
LomaFightsLong <- LomaWideSmall %>%
    
  tidyr::pivot_longer(
      
    spec = LomaSpec,
    
    na.rm = TRUE)

LomaFightsLong


## ----loma-pivot-strike.gif, echo=FALSE, eval=TRUE, fig.cap="http://fightland.vice.com/blog/the-pivots-and-precision-of-vasyl-lomachenko"----
knitr::include_graphics(path =  "https://raw.githubusercontent.com/mjfrigaard/storybenchR/master/02.1-tidyr-tidyverse/images/loma-pivot-strike.gif")


## ----freeze-cells.gif, echo=FALSE, eval=TRUE, fig.cap="freeze cells"-----
# fs::dir_ls("images")
knitr::include_graphics(path = "https://raw.githubusercontent.com/mjfrigaard/storybenchR/master/02.1-tidyr-tidyverse/images/freeze-cells.gif")


## ----pivot-wider---------------------------------------------------------
LomaFights %>% 
    # the columns come from the dates
    tidyr::pivot_wider(names_from = date, 
                       # the values will be the result of the fight
                       values_from = result) %>% 
    # arrange by the fight number 
    dplyr::arrange(no) %>% 
    # rearrange the columns
    dplyr::select(opponent, location,
                  
                  dplyr::starts_with("20"),
                  
                  dplyr::everything())


## ----values_fill---------------------------------------------------------
LomaFights %>% 
    tidyr::pivot_wider(names_from = date, 
                       values_from = result,
                       values_fill = list(result = "")) %>% 
    dplyr::arrange(no) %>% 
    dplyr::select(opponent, 
                  location,
                  dplyr::starts_with("20"))


## ----values_from---------------------------------------------------------
LomaFights %>% 
    dplyr::filter(result == "Win") %>% 
    pivot_wider(names_from = c(type),
                values_from = c(rounds, time),
                values_fill = list(rounds = "",
                                   time = "")) %>% 
    dplyr::select(opponent,
                  dplyr::contains("_KO"),
                  dplyr::contains("_TKO"))


## ----count-pivot---------------------------------------------------------
LomaFights %>% 
    dplyr::filter(!is.na(result)) %>% 
    dplyr::count(type, result) %>% 
    tidyr::pivot_wider(
            names_from = result, 
            values_from = n,
            values_fill = list(n = 0))

