# Description -------------------------------------------------------------
# This script creates a graph of the most read Wikipedia articles in Canada.
#
# It was created in order to experiment with the data obtained via the Wikimedia REST 
# API.
#
# Author: Judith Bourque
# Date: 2022-09-11
#
# Load packages and functions ---------------------------------------------
library(tidyverse)

# Load function
source("R/wikipedia_pageviews_top_per_country.R")

# Load data ---------------------------------------------------------------

df <- rbind(
  pageviews_top_per_country(country = "CA")
)

# Transform data ----------------------------------------------------------

# TODO: filter list with this
#exclude <- c("Special:Search", "Main Page", "Wikipédia:Accueil principal")

# Keep top articles
df_table <- filter(df,
                   rank <= 20)

# Visualize data ----------------------------------------------------------

# Create graph
p <- ggplot(df_table, aes(x = views_ceil, y = reorder(article, -rank))) +
  geom_segment(aes(x=0, xend=views_ceil, yend=article)) +
  geom_point(size = 2, colour = "red")

# Customize graph
p +
  theme_void() +
  labs(
    title = "Most read in Canada",
    subtitle = "Two days after the death of Queen Elizabeth II, the most read articles in Wikipedia are all linked to the British Monarchy.",
    colour = "Date",
    caption = paste("Data: Daily pageviews for", Sys.Date(), "Wikimedia REST API \n Code: github.com/judith-bourque")
    ) +
  ylab("") +
  xlab("views") +
  theme(
    plot.title = element_text(face = "bold"),
    axis.text.y = element_text(hjust = 1),
    axis.text.x = element_text(angle = 270, hjust = 0),
    axis.ticks.x = element_line(),
    axis.title = element_text(hjust = 0.9),
    legend.title = element_text(),
    legend.background = element_rect(fill = "#494949"),
    plot.caption = element_text(hjust = 0.9),
    plot.background = element_rect(fill = "white")
  )

ggsave("graph/wikipedia_pageviews_top_per_country.png", height = 8, width = 12)
