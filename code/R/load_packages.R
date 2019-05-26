# tidyverse packages ------------------------------------------------------
tidy_pkg <- c("dplyr", "forcats", "ggplot2", "haven", "lubridate", "magrittr",
              "purrr", "readr", "readxl", "stringr", "tibble", "tidyr",
              "dbplyr", "tidyverse", "devtools")
# load tidyverse packages -------------------------------------------------
inst_tidy = lapply(tidy_pkg, library, character.only = TRUE)

# common packages ---------------------------------------------------------
com_pkg <- c("ISLR", "e1071", "rio", "memisc", "ggthemes",
             "Hmisc", "e1071", "reshape", "Lahman", "caret", "mosaic",
             "ProjectTemplate", "timevis", "efficient", "tidytext",
             "gutenbergr", "urltools", "xtable")

# load common packages -------------------------------------------------
inst_com = lapply(com_pkg, library, character.only = TRUE)


# devtools::install_github("csgillespie/efficient", build_vignettes =
# TRUE, force = TRUE)
