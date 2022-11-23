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
  start = "2022111400",
  end = "2022112100",
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
  tab_footnote(footnote = "Nov. 14 to 21, 2022.",
               locations = cells_column_labels(columns = views)) %>%
  tab_footnote(footnote = "In bytes.",
               locations = cells_column_labels(columns = length)) %>%
  tab_source_note(., "Code: github.com/judith-bourque") %>%
  # Add space in numbers
  fmt_number(views, sep_mark = ",", decimals = 0) %>%
  fmt_number(length, sep_mark = ",", decimals = 0) %>%
  # Customized version of gtExtras::gt_theme_dark()
  tab_options(
    heading.align = "left",
    heading.border.bottom.style = "none",
    table.background.color = "#2d2d2d",
    table.font.color.light = "white",
    table.border.top.style = "none",
    table.border.bottom.color = "#2d2d2d",
    table.border.left.color = "#2d2d2d",
    table.border.right.color = "#2d2d2d",
    table_body.border.top.style = "none",
    table_body.border.bottom.color = "#2d2d2d",
    column_labels.border.top.style = "none",
    column_labels.background.color = "#2d2d2d",
    column_labels.border.bottom.width = 3,
    column_labels.border.bottom.color = "#2d2d2d",
    data_row.padding = px(7)
  ) %>%
  tab_style(
    style = cell_text(
      color = "white",
      font = google_font("Source Sans Pro"),
      transform = "uppercase"
    ),
    locations = cells_column_labels(everything())
  ) %>%
  tab_style(
    style = cell_text(
      font = google_font("Libre Franklin"),
      weight = 800,
      size = "xx-large"
    ),
    locations = cells_title(groups = "title")
  ) %>%
  tab_style(style = list(
    cell_text(font = google_font("Source Sans Pro"),
              weight = 400),
    cell_borders(color = "#2d2d2d")
  ),
  locations = cells_body()) %>%
  gt_fa_column(like,
               prefer_type = "solid",
               palette = "lightgreen",
               align = "center") %>%
  # Add padding
  opt_horizontal_padding(scale = 3) %>%
  opt_vertical_padding(scale = 1.5) %>%
  opt_table_outline(., style = "none", width = px(0))

# View graph
gt_export

# Save graph
gtsave(gt_export, "graph/wikipedia_pageviews_taylor_swift.png")
