# Description ----
#
# This R script creates a graph of...
#
# It was written as part of an experiment with the Wikimedia API.
#
# Date: 2022-08-01
# Author: Judith Bourque (https://github.com/judith-bourque)
#
## Data sources ----
# Wikimedia Pageviews (https://dumps.wikimedia.org/other/)
# API documentation (https://wikimedia.org/api/rest_v1/)
#
## Code sources ----
#
# Load packages ----
library(tidyverse)
library(httr) # Interact with API
library(jsonlite) # Read API response
library(tidyjson) # Clean json
library(ggplot2)

# Load data ----

## Set parameters ----

my_user_agent <- Sys.getenv("WIKIMEDIA_USER_AGENT") # E-mail for API user agent

## Create dataframe of data ----

# Tidy data ----

tidy_data <- data %>% 
  # Change column name
  rename(pageviews_date = date) %>% 
  # Add concert date
  left_join(., articles) %>%
  # Correct pageviews date
  mutate(pageviews_date = pageviews_date - 1)

# Refine data ----

# Create graph ----

# Save grah

ggsave(
  "graph/filename.png",
  plot = last_plot(),
  path = NULL,
  scale = 1,
  width = 6,
  height = 6,
  units = "in",
  dpi = 300,
  limitsize = TRUE,
  bg = NULL
)
