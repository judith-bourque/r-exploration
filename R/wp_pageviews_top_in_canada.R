# Load packages and functions ---------------------------------------------
library(tidyverse)
library(scales)
library(gt)
library(gtExtras)

# Load function
source("R/wp_pageviews_top_per_country.R")

# Load data ---------------------------------------------------------------

df <- pageviews_top_per_country(country = "CA")

# Transform data ----------------------------------------------------------

exclude <- c("Special:Search", "Main Page", "Wikipédia:Accueil principal")

# Keep top articles
df_table <- df %>% 
  # Remove pages that aren't articles
  dplyr::filter(!article %in% c("Main Page", "Special:Search", "Wikipédia:Accueil principal", "Wikipedia:Featured pictures", "Spécial:Recherche", "Portal:Current events", "Wikipedia:首页", "Wiktionary:Main Page")) %>% 
  # Create new rank column based on articles
  select(!rank) %>% 
  tibble::rowid_to_column("rank") %>% 
  # Keep top 10
  filter(rank <= 15) %>% 
  # Create language column
  separate(project, c("language", "project"), "\\.")

# Visualize data ----------------------------------------------------------

# Set parameters
yesterday <- Sys.Date()-1

year <- format(yesterday, "%Y")
month <- format(yesterday, "%B")
day <- format(yesterday, "%d")

subtitle <- paste0("Most viewed articles in Canada on ", month, " ", day, ",", " ", year, ".")

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
