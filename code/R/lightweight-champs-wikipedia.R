#=====================================================================#
# This is code to create: lightweight fighters from wikipedia
# Authored by and feedback to mjfrigaard@gmail.com
# MIT License
# Version: 2.1.1
#=====================================================================#


# url -------------------------------------------------------------------
url <- "https://en.wikipedia.org/wiki/List_of_lightweight_boxing_champions"


# extract tables --------------------------------------------------------
wikiboxchamptables <- url %>%
  read_html() %>%
  html_nodes("table")
utils::head(wikiboxchamptables)


# locate tables ----------------------------------------------------------
WBCChamps <- rvest::html_table(wikiboxchamptables[[2]], fill = TRUE)
WBAChamps <- rvest::html_table(wikiboxchamptables[[3]], fill = TRUE) 
IBFChamps <- rvest::html_table(wikiboxchamptables[[4]], fill = TRUE) 
WBOChamps <- rvest::html_table(wikiboxchamptables[[5]], fill = TRUE) 

# clean names
WBCChamps <- janitor::clean_names(WBCChamps)
WBAChamps <- janitor::clean_names(WBAChamps)
IBFChamps <- janitor::clean_names(IBFChamps)
WBOChamps <- janitor::clean_names(WBOChamps)

# verify
WBCChamps %>% glimpse(78)
