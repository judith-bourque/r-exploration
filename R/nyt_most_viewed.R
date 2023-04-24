library("tidyverse")

# NYT ---------------------------------------------------------------------

# install.packages("devtools")
devtools::install_github("clessn/nytapi")

library("nytapi")

## Get data ----------------------------------------------------------------

json <- get_most_viewed(key = Sys.getenv("NYT_KEY"))


## Tidy data ---------------------------------------------------------------

results <- json[["results"]]

# Convert to json
json <- results %>%
  tidyjson::as.tbl_json()

# Rectangle JSON into tibble
rect <- tidyjson::spread_all(json) %>%
  janitor::clean_names()


## Visualise data ----------------------------------------------------------




# Wikipedia ---------------------------------------------------------------
# install.packages("devtools")
# devtools::install_github("clessn/wikirest")

library("wikirest")

# Get data ----------------------------------------------------------------

data <- get_most_viewed_per_country(
  country = "US",
  access = "all-access",
  year = "2023",
  month = "04",
  day = "24",
  tidy = TRUE
)
