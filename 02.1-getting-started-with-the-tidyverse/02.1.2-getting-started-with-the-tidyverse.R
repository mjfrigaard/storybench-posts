


# step 1 ----------------------------------------------------------------

TrialData %>%
    dplyr::group_by(result, group) %>%
    dplyr::summarize(count = n())


# step 2 ----------------------------------------------------------------

TrialData %>%
    dplyr::group_by(result, group) %>%
    dplyr::summarize(count = n()) %>% 
    tidyr::spread(result, count)


# step 3 ----------------------------------------------------------------

TrialData %>%
    dplyr::group_by(result, group) %>%
    dplyr::summarize(count = n()) %>% 
    tidyr::spread(result, count) %>% 
    dplyr::select(outcome, `no outcome`) %>% 
    dplyr::arrange(outcome)
