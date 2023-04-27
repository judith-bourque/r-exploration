library("tidyverse")

# Get tidyverse data
tuesdata <- tidytuesdayR::tt_load('2023-04-25')

winners <- tuesdata$winners


# Tidy data ---------------------------------------------------------------

winners_tidy <- janitor::clean_names(winners)

# Analyse data ------------------------------------------------------------

graph_data <- winners %>% 
  count(nationality)

# Visualise data ----------------------------------------------------------

#ggplot(graph_data, aes())
