# Description ----
# Create a graph with an overview of interactions on Wikipedia for a category.
#
# Tutorials: 
# https://towardsdatascience.com/create-animated-bar-charts-using-r-31d09e5841da
# https://stackoverflow.com/questions/53162821/animated-sorted-bar-chart-with-bars-overtaking-each-other
#
# Date: July 2022
# Author: Judith Bourque

# Load ----
library(tidyverse)
library(WikipediR)
library(pageviews)
library(gganimate)
library(gifski) # gif output
library(av) # video output
library(lubridate)

# Designate variables ----

lang <- "en"
proj <- "wikipedia"
cat <- "Musicians from New Brunswick"
lim <- "500"
star <- "2021070100" # YYYYMMDDHH
end <- "2022070100" # YYYYMMDDHH

# Get pages in category ----
pages <- pages_in_category(language = lang,
                  project = proj,
                  categories = cat,
                  type = "page",
                  clean_response = TRUE,
                  limit = lim)

# Get page views ----
pagesVector <- as.vector(pages$title)

data <- data.frame(project = as.character(),
                     language = as.character(),
                     article = as.character(),
                     access = as.character(),
                     agents = as.character(),
                     granularity = as.character(),
                     views = as.numeric())

n <- 0

for (i in 1:nrow(pages)) {
  # Sleep after set number of requests
  n <- n+1
  if (n > 50) {
    Sys.sleep(60)
    n <- 0
  }
  list <- article_pageviews(project = "en.wikipedia", article = pages$title[i], start = star, end = end, granularity = "monthly")
  listDf <- data.frame(list)
  data <- rbind(data, listDf)
}

# Clean data

data$article <- gsub("_", " ", data$article) # Replace "_" by spaces

data <- data %>%
  # Create year column
  mutate(year = format(as.Date(data$date, format="%Y/%m/%d"),"%Y")) %>% 
  # Create month column
  mutate(month = format(as.Date(data$date, format="%Y/%m/%d"),"%B")) %>%
  # Create day column
  mutate(day = format(as.Date(data$date, format="%Y/%m/%d"),"%d"))

# Create graph ----

# Prepare graph data
graphData <- data %>% 
  arrange(ymd(data$date)) %>% 
  group_by(date) %>% 
  mutate(rank = min_rank(-views) * 1) %>%
  ungroup() %>% 
  filter(rank <= 25)

# Set theme
theme_set(theme_classic())

# Create static graph
animGraph <- graphData %>% 
  ggplot(aes(x = rank, group = article, fill = as.factor(article))) +
  geom_tile(aes(y = views/2,
      height = views,
      width = 0.9), alpha = 0.8, color = NA) +
  
  # text in x-axis (requires clip = "off" in coord_*)
  # paste(country, " ")  is a hack to make pretty spacing, since hjust > 1 
  #   leads to weird artifacts in text spacing.
  geom_text(aes(y = 0, label = paste(
    # Cut-off article name
    str_trunc(article, 20, side = "right", ellipsis = "..."), " ")), vjust = 0.2, hjust = 1) +
  
  coord_flip(clip = "off", expand = FALSE) +
  scale_y_continuous(labels = scales::comma) +
  scale_x_reverse() +
  guides(color = FALSE, fill = FALSE) +
  
  labs(title="Most Viewed Wikipedia Articles per Month",
       subtitle = "Category:Musicians from New Brunswick\n{closest_state}", x = "", y = "monthly views") +
  # Add number of views next to bar
  geom_text(aes(y = views,
                label = scales::comma(views)), hjust = 0, nudge_y = 10) +
  theme(plot.title = element_text(hjust = 0, size = 22),
        axis.ticks.y = element_blank(),  # These relate to the axes post-flip
        axis.text.y  = element_blank(),  # These relate to the axes post-flip
        plot.margin = margin(1,1,1,4, "cm")) +
  
  transition_states(date, transition_length = 4, state_length = 1) +
  enter_grow() +
  exit_shrink() +
  ease_aes('linear')

# View graph
print(animGraph)

# Save graph as gif
animate(animGraph, 200, fps = 20,  width = 1200, height = 1000, 
        renderer = gifski_renderer("graph/gganim.gif"))
