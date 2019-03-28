## ----setup, include=FALSE------------------------------------------------
require(tidyverse)
require(mosaic)
require(magrittr)
knitr::opts_chunk$set(
    echo = TRUE, # show all code
    tidy = FALSE, # cleaner code printing
    size = "small") # smaller code
options(width = 80)

## ----filename------------------------------------------------------------
# filename ----------
file_prefix <- c("001.3-") # version #
file_exten <- c(".Rmd")
file_title <- tolower(str_replace_all(
    "String Manipulation in R", 
    pattern = " ",
    replacement = "_"))
file_name <- paste0(file_prefix, file_title, file_exten)
file_name

## ----pre_packages--------------------------------------------------------
library(dplyr) # Data wrangling, glimpse(75) and tbl_df().
library(ggplot2) # Visualise data.
library(lubridate) # Dates and time.
library(readr) # Efficient reading of CSV data.
library(stringr) # String operations.
library(tibble) # Convert row names into a column.
library(tidyr) # Prepare a tidy dataset, gather().
library(magrittr) # Pipes %>%, %T>% and equals(), extract().
library(tidyverse) # all tidyverse packages
library(mosaic) # favstats and other summary functions
library(fs) # file management functions
library(stringi) # more strings
library(tidytext) # tidying text data for analysis
library(maps) # maps for us.cities

## ----packages------------------------------------------------------------
library(tidyverse) # All the goods
library(stringi) # More String Functions
library(magrittr) # Pipes %>%, %T>% and equals(), extract().

## ----news_data, message=FALSE, warning=FALSE-----------------------------
Abc7 <- read_csv("Data/abc7ny.csv")
Kcra <- read_csv("Data/kcra.csv")

## ----Abc7----------------------------------------------------------------
Abc7 %>% glimpse(78)

## ----Kcra----------------------------------------------------------------
Kcra %>% glimpse(78)

## ----identical-----------------------------------------------------------
base::identical(names(Abc7), names(Kcra))

## ----bind_rows-----------------------------------------------------------
# test 
dplyr::bind_rows(Abc7, Kcra, .id = "data_id") %>% 
    dplyr::count(data_id)

## ----NewsData------------------------------------------------------------
# assign
NewsData <- dplyr::bind_rows(Abc7, Kcra, .id = "data_id")
# verify
NewsData %>% 
    dplyr::count(data_id)

## ----NewsData_glimpse----------------------------------------------------
NewsData %>% 
    glimpse(75)

## ----headlines_var-------------------------------------------------------
headlines_var <- NewsData %>% 
    dplyr::select(headline) %>% 
    Matrix::head(5) 

## ----base::is.character--------------------------------------------------
base::is.character(headlines_var)

## ----base::typeof--------------------------------------------------------
base::typeof(headlines_var)

## ----base::unlist--------------------------------------------------------
headlines_var <- headlines_var %>% base::unlist() 
base::is.character(headlines_var)

## ----check_headlines_var-------------------------------------------------
headlines_var %>% utils::str()

## ----headlines_var_names-------------------------------------------------
headlines_var

## ----base::sub-----------------------------------------------------------
base::sub(pattern = "-", replacement = " ", x = headlines_var)

## ----base::gsub----------------------------------------------------------
base::gsub(pattern = "-", replacement = " ", x = headlines_var)

## ----base::chartr--------------------------------------------------------
base::chartr(old = "-", new = " ", x = headlines_var)

## ----base::paste---------------------------------------------------------
base::paste(headlines_var, collapse = "; ")

## ----base::paste0--------------------------------------------------------
base::paste0(headlines_var, sep = "", collapse = "; ")

## ----base::noquote-------------------------------------------------------
base::noquote(headlines_var)

## ----base::cat-----------------------------------------------------------
base::cat(headlines_var, sep = ", ")

## ----stringr::str_to_lower-----------------------------------------------
NewsData %>% 
    dplyr::mutate(headline_low = stringr::str_to_lower(headline)) %>% 
    dplyr::select(headline, headline_low) %>% 
    head(5)

## ----stringr::str_to_title-----------------------------------------------
NewsData %>% 
    dplyr::mutate(headline_title = stringr::str_to_title(headline)) %>% 
    dplyr::select(headline, headline_title) %>% 
    head(5)

## ----stringr::word-------------------------------------------------------
# test
NewsData %>% 
    dplyr::mutate(teaser_3_words = stringr::word(NewsData$teaser, 1, 3)) %>% 
    count(teaser_3_words, sort = TRUE) %>% 
    head(10)

## ----assign_teaser_3_words-----------------------------------------------
NewsData <- NewsData %>% 
    dplyr::mutate(teaser_3_words = stringr::word(NewsData$teaser, 1, 3))

## ----verify_teaser_3_words-----------------------------------------------
NewsData %>% 
    dplyr::count(teaser_3_words, sort = TRUE) %>% 
    utils::head(10)

## ----dplyr::distinct-----------------------------------------------------
NewsData %>% 
    dplyr::distinct(teaser_3_words) %>% 
    base::nrow()

## ----pipeline_demo-------------------------------------------------------
NewsData <- NewsData %>% 
    dplyr::add_count(teaser_3_words) %>% # count this variable and add it
    dplyr::arrange(desc(n)) %>% # arrange the new n data with largest on top
    dplyr::rename(tease_3rd_count = n) %>%  # get rid of n variable
    dplyr::group_by(data_id) %>% # collapse the data frame by news feed
    dplyr::add_tally() %>% # add the total count 
    dplyr::ungroup() %>% # expand the data to all variables again
    dplyr::rename(newsfeed_n = n) %>% # rename n to newsfeed_n
    dplyr::mutate(tease_3rd_prop = tease_3rd_count/newsfeed_n, # create prop
            data_id_fct = factor(data_id, # create factor for ID
                                   levels = c(1, 2),
                                   labels = c("Abc7", 
                                          "Kcra")),
            teaser_3_words = factor(teaser_3_words)) 
NewsData %>% 
    dplyr::glimpse(75)

## ----NewsDataTeaserClevelandPlot-----------------------------------------
NewsDataTeaserClevelandPlot <- NewsData %>% 
    dplyr::arrange(desc(tease_3rd_prop)) %>% # sort desc by the proportion
    dplyr::filter(tease_3rd_count >= 50) %>% # only keep frequecies above 50
    dplyr::filter(!is.na(teaser_3_words)) %>% # remove missing
    # Make the plot
    ggplot2::ggplot(aes(x = tease_3rd_prop, # plot the prop
                        y = fct_reorder(teaser_3_words, # reorder words
                                        tease_3rd_count), # by counts
                     fill = data_id_fct,
                    group = teaser_3_words)) + # fill by feed
    ggplot2::geom_segment(aes(yend = teaser_3_words), 
                     xend = 0, 
                    color = "grey50") +
    ggplot2::geom_point(size = 3, 
                   aes(color = data_id_fct), 
                 show.legend = FALSE) + 
    ggplot2::facet_wrap( ~ data_id_fct, # arrange in 2 columns
           nrow = 2, 
         scales = "free", # free scales
       labeller = as_labeller( # add custom lables
       c(`Abc7` = "ABC7NY News Feed", 
         `Kcra` = "KCRA Sacramento News Feed"))) +
            ggplot2::scale_x_continuous(labels = scales::percent) + # use %
            ggplot2::theme(strip.text.x = element_text(face = "bold")) + # bold type
            ggplot2::labs( # labels and captions
                  x = "Percent First Three Words Appeared", 
                  y = NULL,
            caption = "These are the first three words from headline teasers 
            appearing in ABC7NY and KCRA (from Sacramento)",
              title = "TEAS3RS - Trump, Weather, Police",
           subtitle = "The First Three Words From News Headlines Teasers")
NewsDataTeaserClevelandPlot

## ----ggsave_NewsDataTeaserClevelandPlot----------------------------------
ggsave("./image/NewsDataTeaserClevelandPlot.png", width = 7, height = 5, units = "in")

## ----ggplot2::map_data---------------------------------------------------
State <- ggplot2::map_data("state")
State <- State %>% 
    dplyr::select(state_name = region,
                  state_long = long, 
                  state_lat = lat, 
                  state_group = group, 
                  state_order = order,
                  state_subregion = subregion) 
State %>% 
    dplyr::glimpse(75)

## ----city_id-------------------------------------------------------------
City <- maps::us.cities
City <- City %>% 
    mutate(city_id = stringr::str_replace_all(string = City$name, 
                         pattern = City$country.etc, 
                         replacement = ""),
           city_id = stringr::str_trim(city_id),
           city_id = stringr::str_to_lower(city_id),
           state_abbrev = str_to_lower(country.etc)) %>% 
    dplyr::select(
        city_id,
        city_state_name = name,
        city_lat = lat,
        city_long = long,
        city_pop = pop, 
        city_capital = capital,
        dplyr::everything())
City %>% glimpse(75)

## ----StateAbbLkUp--------------------------------------------------------
StateAbbLkUp <- data_frame("state_abbrev" = as.character(state.abb),
                            "state_name" = as.character(state.name))
StateAbbLkUp <- StateAbbLkUp %>% 
    dplyr::mutate(state_name = str_to_lower(state_name), 
                  state_abbrev = str_to_lower(state_abbrev)) 
StateAbbLkUp %>% glimpse(78)

## ----left_join_StateAbbLkUp----------------------------------------------
StateAbbLkUp <- dplyr::left_join(StateAbbLkUp, 
                                 City, 
                                 by = "state_abbrev") %>% 
                dplyr::left_join(State, by = "state_name") 
StateAbbLkUp %>% 
       dplyr::glimpse(75) 

## ----city_id_vec---------------------------------------------------------
city_id_vec <- StateAbbLkUp %>% 
    distinct(city_state_name, .keep_all = TRUE) %$% unlist(unique(sort(StateAbbLkUp$city_id)))
city_id_vec <- paste(city_id_vec, sep = "", collapse = " | ")

## ----headline_stringr::str_to_lower--------------------------------------
NewsData <- NewsData %>% 
    mutate(headline = stringr::str_to_lower(headline))
NewsData %$% head(headline, 1)

## ----MapNewsData---------------------------------------------------------
MapNewsData <- NewsData %>% 
    filter(stringr::str_detect(string = headline, 
                               pattern = city_id_vec)) %>% 
    dplyr::select(headline, 
            dplyr::everything())
MapNewsData %>% dplyr::glimpse(75)

## ----MapNewsData_city_id-------------------------------------------------
MapNewsData <- MapNewsData %>% 
    mutate(city_id = str_extract(string = MapNewsData$headline, 
                     pattern = paste(city_id_vec, collapse = "|")),
           city_id = stringr::str_trim(city_id)) 
MapNewsData %>% 
    count(city_id, sort = TRUE) %>% 
    head(10)

## ----test_dplyr::inner_join----------------------------------------------
dplyr::inner_join(MapNewsData, StateAbbLkUp, by = "city_id") %>% 
    dplyr::count(city_id, city_state_name) %>% 
    utils::head(9) %>% 
    tidyr::spread(city_state_name, n)

## ----MapNewsData_assign_inner_join---------------------------------------
MapNewsData <- dplyr::inner_join(MapNewsData, StateAbbLkUp, by = "city_id")
MapNewsData %>% glimpse(75)

## ----stringr::str_extract_all--------------------------------------------
stringr::str_extract_all(string = headlines_var, pattern = "[\\d]")

## ----stringr::str_view---------------------------------------------------
stringr::str_view_all(string = "woody allen from allendale and Jimmy Fallen", pattern = "allen")

## ----stringr::str_view_all-----------------------------------------------
stringr::str_view_all(string = "woody allen from allendale", pattern = "\\ballen\\b")

## ----woody_allen_not_allen_tx--------------------------------------------
MapNewsData %>% 
    dplyr::filter(stringr::str_detect(string = headline, 
                      pattern = "\\ballen\\b")) %>% 
    dplyr::select(teaser_3_words,
                  city_id,
                  state_name) %>% 
    head(10)

## ----single_escape, eval=FALSE-------------------------------------------
## stringr::str_extract_all(string = headlines_var, pattern = "[\d]")
## # Error: '\d' is an unrecognized escape in character string starting ""[\d"

## ----double_escape, eval=FALSE-------------------------------------------
## stringr::str_extract_all(string = headlines_var, pattern = "[\\d]")
## # Error: '\d' is an unrecognized escape in character string starting ""[\d"

## ----end_of_line---------------------------------------------------------
MapNewsData %>% 
    dplyr::filter(stringr::str_detect(
        string = teaser_3_words,
        pattern = "police$")) %>% 
    dplyr::select(teaser_3_words) %>% 
    utils::head(5)

## ----replace_police------------------------------------------------------
MapNewsData %>% 
    dplyr::filter(stringr::str_detect(
        string = teaser_3_words,
        pattern = "police$")) %>% 
    dplyr::select(teaser_3_words) %>% 
    utils::head(5) %>% 
    dplyr::mutate(replace_police = 
    stringr::str_replace_all(string = teaser_3_words,
         pattern = "police$",
         replacement = "Royal Gendarmerie of Canada")) %>% 
    utils::head(5)

## ----begin_of_line-------------------------------------------------------
MapNewsData %>% 
    dplyr::filter(stringr::str_detect(
        string = teaser_3_words,
        pattern = "^Trump")) %>% 
    dplyr::select(teaser_3_words) %>% 
    utils::head(5)

## ----replace_begin_of_line-----------------------------------------------
MapNewsData %>% 
    dplyr::filter(stringr::str_detect(
        string = teaser_3_words,
        pattern = "^Trump")) %>% 
    dplyr::select(teaser_3_words) %>% 
    utils::head(5) %>% 
    dplyr::mutate(replace_trump = 
    stringr::str_replace_all(string = teaser_3_words,
         pattern = "^Trump",
         replacement = "The Wu Tang Clan")) %>% 
    utils::head(5)

## ----one_or_more---------------------------------------------------------
MapNewsData %>% 
    dplyr::filter(stringr::str_detect(
        string = teaser_3_words,
        pattern = "[0-9]+")) %>% 
    dplyr::select(teaser_3_words) %>% 
    utils::head(5)

## ----replace_numbers-----------------------------------------------------
MapNewsData %>% 
    dplyr::filter(stringr::str_detect(
        string = teaser_3_words,
        pattern = "[0-9]+")) %>% 
    dplyr::select(teaser_3_words) %>% 
    utils::head(5) %>% 
    dplyr::mutate(replace_numbers = 
    stringr::str_replace_all(string = teaser_3_words,
         pattern = "[0-9]+",
         replacement = "NUMBAS!!")) %>% 
    utils::head(5)

## ----noun----------------------------------------------------------------
noun <- "(a|the) ([^ ]+)"
noun

## ----stringr::str_subset-------------------------------------------------
MapNewsData %$% 
    stringr::str_subset(string = teaser, 
                        pattern = noun) %>%
    stringr::str_extract(noun) %>% 
    utils::head(5)

## ----check_is_vector-----------------------------------------------------
MapNewsData %$% 
    stringr::str_subset(string = teaser, 
                        pattern = noun) %>%
    stringr::str_extract(noun) %>% 
    purrr::is_vector()

## ----tibble::as_data_frame-----------------------------------------------
MapNewsData %$% 
    stringr::str_extract(string = teaser, 
                         pattern = noun) %>% 
    tibble::as_data_frame() %>% 
    utils::head(10)

## ----dplyr::bind_cols----------------------------------------------------
MapNewsData <- MapNewsData %$% 
    stringr::str_extract(string = teaser, 
                         pattern = noun) %>% 
    tibble::as_data_frame() %>% 
    dplyr::bind_cols(MapNewsData) %>% 
    dplyr::rename(tease_noun_phrase = value) 
MapNewsData %>% 
    dplyr::select(tease_noun_phrase, 
                  teaser) %>% 
    utils::head(10)

## ----find_ing------------------------------------------------------------
MapNewsData %>% 
    dplyr::filter(stringr::str_detect(
        string = headline,
        pattern = "\\b[A-Za-z]+ing\\b")) %>% 
    dplyr::select(headline) %>% 
    utils::head(5)

## ----replace_ing---------------------------------------------------------
MapNewsData %>% 
    dplyr::filter(stringr::str_detect(
        string = headline,
        pattern = "\\b[A-Za-z]+ing\\b")) %>% 
    dplyr::select(headline) %>% 
    utils::head(5) %>% 
    dplyr::mutate(replace_ing = 
    stringr::str_replace_all(string = headline,
         pattern = "ing",
         replacement = "in'")) %>% 
    utils::head(5)

## ----tidyr::extract------------------------------------------------------
MapNewsData <- MapNewsData %>%
    tidyr::extract(
        col = teaser, 
        into = c("teaser_article", 
                 "teaser_noun"), 
        regex = "( a|the) ([^ ]+)", 
        remove = FALSE) %>% 
    dplyr::select(teaser_article,
                  teaser_noun, 
    dplyr::everything()) %>% 
    tidyr::extract(
        col = headline, 
        into = c("headline_indef_art", 
                 "headline_indef_noun"), 
        regex = "( an) ([^ ]+)", 
        remove = FALSE) %>% 
    dplyr::select(teaser_article,
        teaser_noun,
        headline_indef_art,
        headline_indef_noun, 
        tease_noun_phrase, 
        headline, 
    dplyr::everything()) %>%
    dplyr::arrange(desc(headline_indef_art))
MapNewsData %>% 
    dplyr::select(headline_indef_art,
                  headline_indef_noun,
                  headline) %>% head(10)

## ----tidyr::separate-----------------------------------------------------
# test
tidyr::separate(MapNewsData, 
         datetime, 
         into = c("month", "day", "year", "at", "hour", "min")) %>% 
    dplyr::select(headline,
                  month:min,
                  dplyr::everything()) %>% 
    dplyr::glimpse(75)

## ----test_datetime-------------------------------------------------------
    tidyr::separate(MapNewsData, 
         datetime, 
          into = c("month", 
                  "day", 
                  "year", 
                  "at", 
                  "hour", 
                  "min")) %>% # I know this works
    dplyr::mutate( # new variables
         month = match(month, month.name), # month.name is loaded with R
           day = as.numeric(day), # make numeric day
          year = as.numeric(year), # # make numeric year
      am_or_pm = stringr::str_sub(min, 
                           start = 3, 
                             end = 4),  # break up min from AM/PM
          hour = if_else(am_or_pm %in% "PM", # condition for 24H time
                 as.numeric(hour) + 12, # 24 hour
                 as.numeric(hour)),
        minute = stringr::str_sub(min, 
                         start = 1, # get the minute elemets
                           end = 2),
           min = as.numeric(minute), # format the minutes
          date = lubridate::make_date(
                   year = year,
                  month = month,
                    day = day), 
      datetime = lubridate::make_datetime( # create the datetime
                   year = year, 
                  month = month, 
                    day = day, 
                   hour = hour, 
                    min = min)) %>% 
    dplyr::glimpse(75)

## ----assign_datetime-----------------------------------------------------
MapNewsData <- MapNewsData %>% 
    tidyr::separate(datetime, 
          into = c("month", 
                  "day", 
                  "year", 
                  "at", 
                  "hour", 
                  "min")) %>% # I know this works
    dplyr::mutate( # new variables
         month = match(month, month.name), # month.name is loaded with R
           day = as.numeric(day), # make numeric day
          year = as.numeric(year), # # make numeric year
      am_or_pm = str_sub(min, 
                           start = 3, 
                             end = 4),  # break up min from AM/PM
          hour = if_else(am_or_pm %in% "PM", # condition for 24H time
                 as.numeric(hour) + 12, # 24 hour
                 as.numeric(hour)),
        minute = str_sub(min, 
                         start = 1, # get the minute elemets
                           end = 2),
                    min = as.numeric(minute), # format the minutes
          date = make_date(
                   year = year,
                  month = month,
                    day = day),
      datetime = lubridate::make_datetime( # create the datetime
                   year = year, 
                  month = month, 
                    day = day, 
                   hour = hour, 
                    min = min))

## ----MapNewsData_Prop_Data-----------------------------------------------
# create data subset
MapNewsData_Prop_Data <- MapNewsData %>% 
    arrange(desc(tease_3rd_prop)) %>% 
    dplyr::select(data_id_fct, 
                  tease_3rd_prop,
                  teaser_3_words,
                  datetime) 
MapNewsData_Prop_Data %>% glimpse(75)

## ----MapNewsLinePlotData-------------------------------------------------
# create base line plot
MapNewsLinePlot <- MapNewsData_Prop_Data %>%
        ggplot2::ggplot(aes(x = datetime, 
                        y = tease_3rd_prop,
                        color = data_id_fct,
                        label = teaser_3_words)) + 
        ggplot2::geom_line(aes(group = data_id_fct)) 
MapNewsLinePlot

## ----ggplot2::ggplot_build-----------------------------------------------
# get colors in this plot
MapNewsLinePlotData <- ggplot2::ggplot_build(MapNewsLinePlot)$data[[1]]
MapNewsLinePlotData %>% distinct(colour)

## ----MapNewsData_Prop_Plot-----------------------------------------------
MapNewsData_Prop_Plot <- MapNewsLinePlot +
        ggplot2::geom_text(data = filter(MapNewsData,
                                    tease_3rd_prop >= 0.020 &
                                    datetime <= "2017-11-15"),
                                    aes(label = teaser_3_words),
                                        vjust = 2,
                                        hjust = 1,
                                        show.legend = FALSE,
                                        color = "#F8766D") +
            ggplot2::geom_text(data = filter(MapNewsData,
                                    tease_3rd_prop >= 0.020 &
                                    datetime >= "2017-11-15" & 
                                    datetime <= "2017-12-7"),
                                    aes(label = teaser_3_words),
                                        vjust = 0.7,
                                        hjust = 0.9,
                                        show.legend = FALSE,
                                        color = "#F8766D") +
            ggplot2::geom_text(data = filter(MapNewsData,
                                    tease_3rd_prop >= 0.020 &
                                    datetime >= "2017-12-7"),
                                    aes(label = teaser_3_words),
                                        vjust = 2,
                                        hjust = 0.09,
                                        show.legend = FALSE,
                                        color = "#F8766D") +
            ggplot2::geom_text(data = filter(MapNewsData,
                                    tease_3rd_prop > 0.015 &
                                    datetime <= "2017-09-01"),
                                    aes(label = teaser_3_words),
                                        vjust = 0.9,
                                        hjust = 0.1,
                                        show.legend = FALSE,
                                        color = "#00BFC4") +
            ggplot2::geom_text(data = filter(MapNewsData,
                                    tease_3rd_prop > 0.015 &
                                    datetime >= "2017-11-01" & 
                                    data_id_fct == "Kcra"),
                                    aes(label = teaser_3_words),
                                        vjust = 0.9,
                                        hjust = 0.1,
                                        show.legend = FALSE,
                                        color = "#00BFC4") +
            ggplot2::theme(legend.position = "top") +
            ggplot2::labs(x = "Date",
                      y = NULL,
                      color = "News Feed",
                      caption = "Proportion First Three Words Appeared") + 
            ggplot2::ggtitle("ABC7 & KCRA Teaser First Three Word Occurrences July 18 to January 16")
MapNewsData_Prop_Plot

## ----ggsave_MapNewsData_Prop_Plot----------------------------------------
ggsave("./image/MapNewsData_Prop_Plot.png", width = 7, height = 5, units = "in")

## ----session_info, echo=TRUE---------------------------------------------
devtools::session_info()  # put this at the end of document

