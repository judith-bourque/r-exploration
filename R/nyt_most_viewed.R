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

# Set parameters
yesterday <- Sys.Date()-1

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

exclude <- paste("Main Page", "Portal:", "Spécial:", "Special", "Wikipedia:", "Wikidata:", "Wikipédia", "Wiktionary:", sep = "|")

dplyr::filter(data_tidy, !grepl(exclude, article))

# Keep top articles
data_table <- data_tidy %>% 
  # Remove pages that aren't articles
  dplyr::filter(!article %in% exclude) %>% 
  # Create new rank column based on articles
  select(!rank) %>% 
  tibble::rowid_to_column("rank") %>% 
  # Keep top 10
  filter(rank <= 15) %>% 
  # Create language column
  separate(project, c("language", "project"), "\\.")


# Visualise data ----------------------------------------------------------

month <- format(yesterday, "%B")

subtitle <- paste0("Most viewed articles in the US on ", month, " ", day, ",", " ", year, ".")

caption_1 <- paste0("Source: Wikimedia REST API.")
caption_2 <- "Code: github.com/judith-bourque"

views_min <- min(df_table$views_ceil)
views_max <- max(df_table$views_ceil)


# Create graph
gt_export <- df_table %>% 
  select(c(rank, article, language, views_ceil)) %>% 
  gt() %>% 
  cols_label(
    language = "Lang",
    views_ceil = "Views ceiling"
  ) %>% 
  # Add space in numbers
  fmt_number(views_ceil, sep_mark = " ", decimals = 0) %>% 
  tab_header(
    title = md("**What are Canadians reading on Wikipedia?**"),
    subtitle = subtitle
  ) %>% 
  gt_color_rows(views_ceil, palette = "ggsci::red_material", domain = c(views_min, views_max)) %>% 
  tab_source_note(caption_1) %>% 
  tab_source_note(caption_2) %>% 
  gt_theme_538()

# View graph
gtsave(gt_export, "graph/graph.png")

knitr::include_graphics('graph/wp_pageviews_top_in_canada.png')