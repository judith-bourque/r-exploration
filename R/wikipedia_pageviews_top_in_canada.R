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
library(scales)

# Load function
source("R/wikipedia_pageviews_top_per_country.R")

# Load data ---------------------------------------------------------------

df <- rbind(
  pageviews_top_per_country(country = "CA")
)

# Transform data ----------------------------------------------------------

# TODO: filter list with this
exclude <- c("Special:Search", "Main Page", "Wikipédia:Accueil principal")

# Keep top articles
df_table <- dplyr::filter(df,
                   rank <= 20,
                   !article %in% c("Main Page", "Special:Search", "Wikipédia:Accueil principal", "Wikipedia:Featured pictures", "Spécial:Recherche", "Portal:Current events", "Wikipedia:首页", "Wiktionary:Main Page"))

# Visualize data ----------------------------------------------------------

# Create graph
p <- ggplot(df_table, aes(x = views_ceil, y = reorder(article, -rank))) +
  geom_segment(aes(x=0, xend=views_ceil, yend=article), colour = "grey") +
  geom_point(size = 2, colour = "red") +
  # TODO: Shorten text labels on Y axis
  #scale_y_discrete(labels = scales::label_wrap(20)) +
  scale_x_continuous(labels = scales::label_comma()) +
  # Customize
  theme_void() +
  labs(
    title = "What Canadians are currently reading on Wikipedia",
    subtitle = "British royalty and Conservative Party of Canada gather the most attention.",
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
    plot.caption = element_text(hjust = 0.9),
    #plot.background = element_rect(fill = "white"),
    panel.grid.major.y = element_blank()
  )

p

ggsave("graph/wikipedia_pageviews_top_in_canada.png", height = 8, width = 12)
