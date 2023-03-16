# Taylor Swift's most popular songs on Wikipedia

library("tidyverse")
library("lubridate")
library("gt")
library("gtExtras")
tidywikidatar::tw_enable_cache()
tidywikidatar::tw_set_cache_folder(path = fs::path(fs::path_home_r(), "R", "tw_data"))
tidywikidatar::tw_set_language(language = "en")
tidywikidatar::tw_create_cache_folder(ask = FALSE)

# Get article list --------------------------------------------------------

# Get list of songs
query_df <- tibble::tribble(~ p, ~ q,
                            "P175", "Q26876")

resp_raw <- tidywikidatar::tw_query(query = query_df) %>%
  tidywikidatar::tw_filter(., "P31", "Q134556")

# Get Wikipedia pages of songs
resp_raw$pages <-
  tidywikidatar::tw_get_wikipedia(resp_raw$id, full_link = FALSE)

resp <- resp_raw %>%
  na.omit() %>%
  mutate(length = NA,
         last_edited = NA) %>%
  rename(article = pages)


# Get article length ------------------------------------------------------

article_vect <- resp$article

for (i in 1:length(article_vect)) {
  page_resp <-
    WikipediR::page_info(
      language = "en",
      project = "wikipedia",
      page = article_vect[i],
      clean_response = TRUE
    )
  
  resp[[i, "length"]] <- page_resp[[1]][["length"]]
  resp[[i, "last_edited"]] <- page_resp[[1]][["touched"]]
}

# Get article pageviews ---------------------------------------------------

views_raw <- pageviews::article_pageviews(
  project = "en.wikipedia",
  article = resp$article,
  platform = "all",
  user_type = "user",
  start = "2023030800",
  end = "2023031500",
  reformat = TRUE,
  granularity = "daily"
)

views <- views_raw %>%
  group_by(article) %>% 
  summarise(views = sum(views)) %>% 
  ungroup() %>% 
  mutate(article = gsub("_", " ", article))

# Create table data -------------------------------------------------------

data_full <- full_join(resp, views, by = "article")

data_tb <- data_full %>%
  arrange(desc(views)) %>%
  slice_head(n = 10) %>%
  mutate(
    rank = seq(1:10),
    like = "heart",
    last_edited = format(as_datetime(last_edited), "%b. %d, %Y"),
  ) %>%
  select(rank, label, views, last_edited, like, length)


# Visualize data ----------------------------------------------------------
theme_spotify <- function(gt_object, background_colour = "#2d2d2d", ...) {
  stopifnot("'gt_object' must be a 'gt_tbl'." = "gt_tbl" %in% class(gt_object))
  
  gt_object %>%
    gt::tab_options(
      heading.align = "left",
      heading.border.bottom.style = "none",
      table.background.color = background_colour,
      table.font.color.light = "white",
      table.border.top.style = "none",
      table.border.bottom.color = background_colour,
      table.border.left.color = background_colour,
      table.border.right.color = background_colour,
      table_body.border.top.style = "none",
      table_body.border.bottom.color = background_colour,
      column_labels.border.top.style = "none",
      column_labels.background.color = background_colour,
      column_labels.border.bottom.width = 3,
      column_labels.border.bottom.color = background_colour,
      data_row.padding = gt::px(7),
    ) %>%
    gt::tab_style(
      style = gt::cell_text(
        color = "white",
        font = gt::google_font("Source Sans Pro"),
        transform = "uppercase"
      ),
      locations = gt::cells_column_labels(tidyselect::everything())
    ) %>%
    gt::tab_style(
      style = gt::cell_text(
        font = gt::google_font("Libre Franklin"),
        weight = 800,
        size = "xx-large"
      ),
      locations = gt::cells_title(groups = "title")
    ) %>%
    gt::tab_style(style = list(
      gt::cell_text(font = gt::google_font("Source Sans Pro"),
                    weight = 400),
      gt::cell_borders(color = background_colour)
    ),
    locations = gt::cells_body()) %>%
    # Add padding
    gt::opt_horizontal_padding(scale = 3) %>%
    gt::opt_vertical_padding(scale = 1.5) %>%
    gt::opt_table_outline(style = "none", width = gt::px(0))
  
}

gt_export <- data_tb %>%
  gt() %>%
  tab_header(.,
             title = "Taylor Swift",
             subtitle = "Popular songs on English Wikipedia") %>%
  # Relabel columns
  cols_label(
    rank = "#",
    label = "title",
    last_edited = "last edited",
    like = ""
  ) %>%
  tab_footnote(footnote = "March 8 to 15, 2023.",
               locations = cells_column_labels(columns = views)) %>%
  tab_footnote(footnote = "In bytes.",
               locations = cells_column_labels(columns = length)) %>%
  tab_source_note(., "Code: github.com/judith-bourque") %>%
  # Add space in numbers
  fmt_number(views, sep_mark = ",", decimals = 0) %>%
  fmt_number(length, sep_mark = ",", decimals = 0) %>%
  # Customized version of gtExtras::gt_theme_dark()
  theme_spotify(background_colour = "#3c354d") %>% 
  gt_fa_column(like,
               prefer_type = "solid",
               palette = "#e2d5f1",
               align = "center")

# View graph
gt_export

# Save graph
gtsave(gt_export, "graph/wikipedia_pageviews_taylor_swift.png")
