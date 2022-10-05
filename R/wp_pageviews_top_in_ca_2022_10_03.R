# Description -------------------------------------------------------------
# This script creates a graph of the most read Wikipedia articles in Canada.
# It highlights articles related to the 2022 Quebec elections.
#
# Author: Judith Bourque
# Date: 2022-10-04
#
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
caption_1 <- paste0("Source: Page vues quotidiennes des articles les plus consultés au Canada, Wikimedia REST API.")
caption_2 <- "Code: github.com/judith-bourque"

# Create graph
gt_export <- df_table %>% 
  select(c(rank, article, language, views_ceil)) %>% 
  gt() %>% 
  cols_label(
    rank = "Rang",
    language = "Langue",
    views_ceil = "Plafond de vues"
  ) %>% 
  # Add space in numbers
  fmt_number(views_ceil, sep_mark = " ", decimals = 0) %>% 
  tab_header(
    title = md("**Les canadiens s'informent-ils sur les élections québécoises?**"),
    subtitle = "Les articles Wikipédia les plus consultés au Canada le 3 octobre 2022."
  ) %>% 
  gt_color_rows(views_ceil, palette = "ggsci::blue_material", domain = c(0, 105000)) %>% 
  tab_source_note(caption_1) %>% 
  tab_source_note(caption_2) %>% 
  gt_theme_538() %>% 
  gt_highlight_rows(
    columns = rank:language,
    rows = c(7, 13, 15),
    fill = "lightgrey",
    alpha = 0.8,
    font_weight = "bold",
    bold_target_only = TRUE,
    target_col = article
  )

# View graph
gt_export

# Save graph
gtsave(gt_export, "graph/wp_pageviews_top_in_ca_2022_10_03.png", expand = 30)
