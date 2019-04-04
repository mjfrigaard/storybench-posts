


# create DataTibble ----



DataTibble <- tibble(
    group_var = c("A", "A", "A", "B", "B", "C", "C", "C"), 
    year = c(2018, 2017, 2016, 2018, 2017, 2018, 2017, 2016),
    x_measurement = runif(8, min = 0, max = 100), 
    y_messurement = runif(8, min = 101, max = 1000)) %>% 
    dplyr::mutate(ordinal_x_var = 
                    case_when(
                      x_measurement >= 75 ~ "high",
                      x_measurement >= 50 & x_measurement < 75 ~ "med",
                      x_measurement < 50 ~ "low"),
                    ordinal_x_var = factor(ordinal_x_var, 
                                levels = c("high", 
                                           "med", 
                                           "low"),
                                labels = c(3, 2, 1)))