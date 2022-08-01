# Description ----
#
# This R script creates an animated graph of the Wikipedia pageviews of
# the Festival d'été de Québec headliners before and after their
# performance.
#
# It was created in order to experiment with the Wikimedia API.
#
# Date: 2022-07-31
# Author: Judith Bourque (https://github.com/judith-bourque)
#
## Data sources ----
# Wikimedia Pageviews (https://dumps.wikimedia.org/other/)
# API documentation (https://wikimedia.org/api/rest_v1/)
# FEQ schedule (https://www.feq.ca/Programmation/Affiche)
#
## Code sources ----
# gganimate: how to create plots with beautiful animation in R (https://www.datanovia.com/en/blog/gganimate-how-to-create-plots-with-beautiful-animation-in-r/)
# Accessing APIs from R (and a little R programming) (https://www.r-bloggers.com/2015/11/accessing-apis-from-r-and-a-little-r-programming/)
# Customizing time and date scales in ggplot2 (https://www.r-bloggers.com/2018/06/customizing-time-and-date-scales-in-ggplot2/)
#
## See also ----
# How to create animations in R with gganimate (https://anderfernandez.com/en/blog/how-to-create-animations-in-r-with-gganimate/)
# Animated line chart in R (https://datavizstory.com/animated-line-chart-in-r/)
#
# Load packages ----
library(tidyverse)
library(httr) # Interact with API
library(jsonlite) # Read API response
library(tidyjson) # Clean json
library(ggplot2)
library(gganimate) # Create animated ggplot
library(ggrepel) # repel labels and text

# Load data ----

# Set parameters
# 2 weeks before start of FEQ: June 22
# Start of FEQ: July 6
# End of FEQ: July 16
# 2 weeks after end of FEQ: July 30

my_user_agent <- "" # E-mail for API user agent

project <- "fr.wikipedia.org"
access <- "all-access" # all-access, desktop, mobile-app, mobile-web
agent <- "user" # all-agents, user, spider, automated
granularity <- "daily" # daily, monthly
start <- "2022062200" # YYYYMMDDHH
end <- "2022073000" # YYYYMMDDHH

## Create dataframe of articles ----
articles <- data.frame(date = c("2022-07-06",
                                "2022-07-07",
                                "2022-07-08",
                                "2022-07-09",
                                "2022-07-10",
                                "2022-07-11",
                                "2022-07-12",
                                "2022-07-13",
                                "2022-07-14",
                                "2022-07-15",
                                "2022-07-16",
                                "2022-07-17"),
                       name = c("Charlotte Cardin",
                                "Jack Johnson",
                                "Luke Combs",
                                "Maroon 5",
                                "Suicideboys",
                                "Halsey",
                                "Loud",
                                "Marshmello",
                                "Luis Fonsi",
                                "Alanis Morissette",
                                "Rage Against the Machine",
                                "Half Moon Run"),
                       article = c("Charlotte_Cardin",
                                   "Jack_Johnson_(musicien)",
                                   "Luke_Combs",
                                   "Maroon_5",
                                   "Suicideboys",
                                   "Halsey_(chanteuse)",
                                   "Loud_(rappeur)",
                                   "Marshmello",
                                   "Luis_Fonsi",
                                   "Alanis_Morissette",
                                   "Rage_Against_the_Machine",
                                   "Half_Moon_Run"))

## Create dataframe of pageviews ----

data <- data.frame()

n <- 0 # To allow sleep after set number of requests

for (i in 1:nrow(articles)) {
  
  # Sleep after set number of requests
  n <- n+1
  if (n > 100) {
    Sys.sleep(120)
    n <- 0
  }
  
  # Get response from API
  response <- GET(url = paste("https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article",
                              project, access, agent, articles$article[i], granularity,
                              start, end, sep = "/"),
                  user_agent(my_user_agent))
  
  # TIDY DATA
  
  # Convert response to data frame
  response_content_df <- fromJSON(rawToChar(response$content))[["items"]] %>% 
  separate(col = timestamp, c("date", "hour"), sep = 8)
  
  # Add name of artist
  response_content_df$name <- articles$name[i]
  # Clean up date
  response_content_df$date <- as.Date(response_content_df$date, "%Y%m%d")
  
  # Combine data frames
  data <- rbind(data, response_content_df)
}

# Refine data ----

refined_data <- data %>% 
  # top
  group_by(date) %>% 
  mutate(rank = min_rank(-views) * 1) %>%
  ungroup()

# Create static graph ----

graph <- refined_data %>% 
  ggplot(aes(x = date, y = views, group = article)) +
  geom_line(aes(color = article)) +
  scale_color_viridis_d() +
  labs(title = "Wikipédia pageviews des artistes de la FEQ",
       x = "Date", y = "Pageviews") +
  # Line start FEQ
  geom_vline(aes(xintercept = as.numeric(lubridate::date("2022-07-06"))), linetype="dotted") +
  # Line end FEQ
  geom_vline(aes(xintercept = as.numeric(lubridate::date("2022-07-17"))), linetype="dotted")

print(graph)

# ggsave

# Create animated graph ----
static_graph <- refined_data %>% 
  ggplot(aes(x = date, y = views, group = article)) +
  geom_line(aes(color = article)) +
  scale_color_viridis_d() +
  labs(title = "Wikipédia pageviews des artistes de la FEQ",
    x = "Date", y = "Pageviews")#+
  #theme(legend.position = "none")
  

animated_graph <- static_graph + geom_point() +
  # Line start FEQ
  geom_vline(aes(xintercept = as.numeric(lubridate::date("2022-07-06"))), linetype="dotted") +
  # Line end FEQ
  geom_vline(aes(xintercept = as.numeric(lubridate::date("2022-07-17"))), linetype="dotted") +
  # Titre des lignes
  geom_label_repel(
    data=refined_data %>% filter(rank == 1), # Filter data first
    aes(label=name)) +
  transition_reveal(date)

print(animated_graph)

# Save graph as gif
gganimate::animate(animated_graph, height = 256, width = 512,#width = 1200, height = 1000, 
                   renderer = gifski_renderer("graph/wikipedia_pageviews_by_article_feq.gif"))
