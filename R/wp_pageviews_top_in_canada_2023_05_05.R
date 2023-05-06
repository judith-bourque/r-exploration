# Wikipedia ---------------------------------------------------------------
# install.packages("devtools")
# devtools::install_github("clessn/wikirest")

library("wikirest")
library("tidyverse")

# Get data ----------------------------------------------------------------

# Set parameters
yesterday <- Sys.Date() - 1

year <- format(yesterday, "%Y")
month <- format(yesterday, "%m")
day <- format(yesterday, "%d")

timeline <- seq(yesterday - 7, yesterday, by = '1 day')

data_raw <- map(timeline, ~ get_most_viewed_per_country(
  country = "CA",
  access = "all-access",
  date = .x,
  tidy = TRUE
))

data_raw <- bind_rows(data_raw)

# Wrangle and tidy data ---------------------------------------------------

# Clean article names
data_tidy <- data_raw %>%
  dplyr::mutate(
    article = gsub("_", " ", article),
    date = as.POSIXct(paste(year, month, day, sep = "-"), tz = "UTC"),
    country = country,
    access = access
  )

exclude <-
  paste(
    "Main Page",
    "Portal:",
    "Spécial:",
    "Special",
    "Wikipedia:",
    "Wikidata:",
    "Wikipédia",
    "Wiktionary:",
    sep = "|"
  )

# Keep top articles
data_table <- data_tidy %>%
  # Remove pages that aren't articles
  dplyr::filter(!grepl(exclude, article)) %>%
  # Create new rank column based on articles
  select(!rank) %>%
  tibble::rowid_to_column("rank") %>%
  # Keep top 10
  #filter(rank <= 20) %>%
  # Create language column
  separate(project, c("language", "project"), "\\.")


# Visualise data ----------------------------------------------------------

month <- format(yesterday, "%B")

subtitle <-
  paste0("Most viewed articles in Canada on ", month, " ", day, ",", " ", year, ".")
caption_1 <- paste0("Source: Wikimedia REST API.")
caption_2 <- "Code: github.com/judith-bourque"

ggplot(data_table, aes(x = date, y = views_ceil, group = article)) +
  geom_line() +
  gghighlight::gghighlight(max(views_ceil) > 40000) +
  labs(title = "What are Canadians reading on Wikipedia?",
       subtitle = subtitle)

# ggsave("graph/wp_pageviews_top_in_canada_2023-05-05.png")