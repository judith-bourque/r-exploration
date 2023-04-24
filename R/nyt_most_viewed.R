# install.packages("devtools")
devtools::install_github("clessn/nytapi")

library("nytapi")
library("tidyverse")


# Get data ----------------------------------------------------------------

json <- get_most_viewed(key = Sys.getenv("NYT_KEY"))


# Tidy data ---------------------------------------------------------------

results <- json[["results"]]

# Convert to json
json <- results %>%
  tidyjson::as.tbl_json()

# Rectangle JSON into tibble
rect <- tidyjson::spread_all(json) %>%
  janitor::clean_names()


# Visualise data ----------------------------------------------------------


