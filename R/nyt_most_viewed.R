# install.packages("devtools")
devtools::install_github("clessn/nytapi")

library("nytapi")
library("tidyverse")


# Get data ----------------------------------------------------------------

json <- get_most_viewed(key = Sys.getenv("NYT_KEY"))


# Tidy data ---------------------------------------------------------------

article <- json[["results"]][[1]]

article[["title"]]
article[["byline"]]
article[["published_date"]]

# Visualise data ----------------------------------------------------------


