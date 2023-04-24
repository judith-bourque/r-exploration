library("tidyverse")
library("gt")
library("gtExtras")

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

data_table <- rect %>%
  as_tibble() %>%
  select(section, title) %>%
  #arrange(section) %>%
  group_by(section)

## Visualise data ----------------------------------------------------------

today <- Sys.Date()

year <- format(today, "%Y")
month <- format(today, "%B")
day <- format(today, "%d")

subtitle <-
  paste0("Most viewed articles by section on ", month, " ", day, ",", " ", year, ".")

caption_1 <- paste0("Source: NYT API.")
caption_2 <- "Code: github.com/judith-bourque"

gt_export <- data_table %>%
  gt() %>%
  tab_header(title = md("**What are people reading in the New York Times?**"),
             subtitle = subtitle) %>%
  tab_source_note(caption_1) %>%
  tab_source_note(caption_2) %>%
  gt_theme_538() %>%
  # tab_style(style = list(
  #   cell_text(weight = "bold"),
  #   cell_borders(sides = "all", color = "white", style = "solid", weight = px(0))
  # ),
  # locations = cells_row_groups(groups = everything())) %>%
  tab_style(style = list(
    cell_text(indent = px(30)),
    cell_borders(sides = "bottom", color = "white", style = "solid", weight = px(1))
  ),
  locations = cells_body(columns = title)) %>%
  # Edit group section
  tab_style(
    style = list(
      cell_borders(
        sides = "top", color = "black", weight = px(0)
      ),
      cell_text(
        font = google_font("Chivo"),
        transform = "uppercase",
        v_align = "bottom",
        size = px(14),
        weight = 200
      )
    ),
    locations = cells_row_groups(groups = everything())
  ) %>% 
  #
  tab_options(column_labels.hidden = TRUE)

gt_export


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
gt_export <- data_table %>%
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
                palette = "ggsci::red_material",
                domain = c(views_min, views_max)) %>%
  tab_source_note(caption_1) %>%
  tab_source_note(caption_2) %>%
  gt_theme_538()

# View graph
gt_export

#gtsave(gt_export, "graph/graph.png")

#knitr::include_graphics('graph/wp_pageviews_top_in_canada.png')