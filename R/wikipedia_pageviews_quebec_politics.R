# Description -------------------------------------------------------------
#
# This R script creates a graph of the top 10 French Wikipedia articles about
# Quebec politics in the last 7 days.
#
# It was written as part of an experiment with data visualization.
#
# The visualization was inspired by the Top read Wikipedia iPhone widget.
#
# Date: 2022-08-28
# Author: Judith Bourque (https://github.com/judith-bourque)
#
## Data sources ------------------------------------------------------------
#
# Wikimedia Pageviews (https://dumps.wikimedia.org/other/)
# API documentation (https://wikimedia.org/api/rest_v1/)
# Petscan of category Portail:Politique québécoise/Articles liés (https://petscan.wmflabs.org/)
# Load packages -----------------------------------------------------------

library(tidyverse)
library(pageviews) # Get pageviews data
library(gtExtras) # Table visualization
library(gt) # Table customization
library(lubridate)

# Load data ---------------------------------------------------------------

# Set request parameters

project <- "fr.wikipedia"
access <- "all-access" # all-access, desktop, mobile-app, mobile-web
agent <- "user" # all-agents, user, spider, automated
granularity <- "daily" # daily, monthly
start <- "2022090100" # YYYYMMDDHH
end <- "2022090800" # YYYYMMDDHH
key <- "quebec_politics" # key to link to data and graph

# Get list of articles

articles <-
  read_csv(paste0("data/wikipedia_pages_in_category_", key, ".csv")) # TODO: automate with query https://meta.wikimedia.org/wiki/PetScan/en

# Get pageviews data

data_list <- list()

for (i in 1:nrow(articles)) {
  response_df <- pageviews::article_pageviews(
    project = project,
    articles$title[i],
    user_type = agent,
    start = start,
    end = end,
    granularity = granularity
  )
  
  # Consolidate
  data_list[[i]] <- response_df
}

# Combine data frames
dataframe <- bind_rows(data_list)

# Tidy data ---------------------------------------------------------------

ordered_data <- dataframe %>%
  # Change column name
  rename(pageviews_date = date) %>%
  mutate(# Clean article name
    article = gsub("_", " ", article)) %>%
  group_by(., article) %>%
              #summarise(total_views = sum(views))
              mutate(end_views = last(views)) %>%
  arrange(desc(end_views))

# Table -------------------------------------------------------------------

table_data <- ordered_data %>%
  # Slice top 10 articles
  dplyr::group_by(article) %>%
  dplyr::summarise(
    views_data = list(views),
    end_views = mean(end_views),
    .groups = "drop"
  ) %>%
  arrange(desc(end_views)) %>%
  # Add numbers
  slice(1:10) %>%
  mutate(number = seq(1:10)) %>%
  # Reorder columns
  select(number, article, views_data, end_views)

graph <- table_data %>%
  # Create table
  gt() %>%
  # Add sparkline graph
  gt_plt_sparkline(
    views_data,
    type = "shaded",
    palette = c("black", "black", "blue", "aquamarine", "lightblue"),
    same_limit = F,
    label = F
  ) %>%
  # Add header
  tab_header(title = md("**Les plus lus**"),
             subtitle = "Sur la politique québécoise dans Wikipédia en français") %>%
  # Specify column labels
  cols_label(
    number = "",
    article = "Article",
    views_data = "Vues",
    end_views = "") %>%
    # Specify date of data
    tab_source_note(source_note = paste(
      format(today() - days(8)), " - ",
      format(today() - days(1))
    )) %>%
      # Specify source
      tab_source_note(source_note = "Données: Wikimedia REST API") %>%
      # Specify author
      tab_source_note(source_note = "Code: github.com/judith-bourque") %>%
      # Theme
      gt_theme_538()
    
graph
    
graph %>%
  # Save the graph
  gtsave(paste0("graph/wikipedia_pageviews_", key, ".png"))
