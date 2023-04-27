library("tidyverse")

# Get tidyverse data
tuesdata <- tidytuesdayR::tt_load('2023-04-25')

winners <- tuesdata$winners

# Get map data
world_maps <- map_data("world")

# Tidy data ---------------------------------------------------------------

winners_tidy <- janitor::clean_names(winners)

# Analyse data ------------------------------------------------------------

graph_data <- winners %>% 
  count(nationality)

# Compute the centroid as the mean longitude and lattitude
# Used as label coordinate for country's names
region_lab_data <- world_maps %>%
  filter(region %in% winners_tidy$nationality) %>%
  group_by(region) %>%
  summarise(longitude = mean(long), latitude = mean(lat))

# Visualise data ----------------------------------------------------------

