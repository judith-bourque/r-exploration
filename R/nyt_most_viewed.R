library("tidyverse")
library("gt")
library("gtExtras")

# NYT ---------------------------------------------------------------------

# install.packages("devtools")
# devtools::install_github("clessn/nytapi")

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

data_table <- rect %>%
  as_tibble() %>%
  select(section, title) %>% 
  arrange(section) %>% 
  rename(article = title)

## Visualise data ----------------------------------------------------------

today <- Sys.Date()

year <- format(today, "%Y")
month <- format(today, "%B")
day <- format(today, "%d")

subtitle <-
  paste0("Most viewed articles by section on ", month, " ", day, ",", " ", year, ".")

caption_1 <- paste0("Source: The New York Times Most Popular API.")
caption_2 <- "Code: github.com/judith-bourque"

gt_nyt <- data_table %>%
  gt() %>%
  tab_header(title = md("**What are people reading in the New York Times?**"),
             subtitle = subtitle) %>%
  tab_source_note(caption_1) %>%
  tab_source_note(caption_2) %>%
  tab_style(style = list(cell_text(align = "right")),
            location = cells_body(columns = "section")) %>% 
  tab_style(style = list(cell_text(align = "right")),
            location = cells_column_labels(columns = section)) %>% 
  gt_theme_538()

gt_nyt

gtsave(gt_nyt, "graph/nyt_most_viewed_2023_04_24.png")

# Wikipedia ---------------------------------------------------------------
# install.packages("devtools")
# devtools::install_github("clessn/wikirest")

library("wikirest")

# Get data ----------------------------------------------------------------

# Set parameters
yesterday <- Sys.Date() - 1

year <- format(yesterday, "%Y")
month <- format(yesterday, "%m")
day <- format(yesterday, "%d")


data_raw <- get_most_viewed_per_country(
  country = "US",
  access = "all-access",
  year = year,
  month = month,
  day = day,
  tidy = TRUE
)

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
  filter(rank <= 20) %>%
  # Create language column
  separate(project, c("language", "project"), "\\.")


# Visualise data ----------------------------------------------------------

month <- format(yesterday, "%B")

subtitle <-
  paste0("Most viewed articles in the US on ", month, " ", day, ",", " ", year, ".")

caption_1 <- paste0("Source: Wikimedia REST API.")
caption_2 <- "Code: github.com/judith-bourque"

views_min <- min(data_table$views_ceil)
views_max <- max(data_table$views_ceil)

# Create graph
gt_wiki <- data_table %>%
  select(c(rank, article, language, views_ceil)) %>%
  gt() %>%
  cols_label(language = "Lang",
             views_ceil = "Views ceiling") %>%
  # Add space in numbers
  fmt_number(views_ceil, sep_mark = " ", decimals = 0) %>%
  tab_header(
    title = md("**What are Americans reading on Wikipedia?**"),
    subtitle = subtitle
  ) %>%
  gt_color_rows(views_ceil,
                palette = "ggsci::green_material",
                domain = c(views_min, views_max)) %>%
  tab_source_note(caption_1) %>%
  tab_source_note(caption_2) %>%
  gt_theme_538()

# View graph
gt_wiki

gtsave(gt_wiki, "graph/wp_pageviews_top_in_us_2024-04-23.png")
