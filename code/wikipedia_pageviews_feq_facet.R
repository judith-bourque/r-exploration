# Description ----
#
# This R script creates a graph of the Wikipedia pageviews of the Festival d'été
# de Québec headliners around the time of their performance.
#
# It was written as part of an experiment with the Wikimedia API.
#
# Please note:
# The Wikimedia pageviews timestamps correspond with the end of the recorded
# period in UTC. Dates have been adjusted to reflect the day recorded in UTC. 
# The article for Luke Combs was created on July 10th 2022.
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
# Accessing APIs from R (and a little R programming) (https://www.r-bloggers.com/2015/11/accessing-apis-from-r-and-a-little-r-programming/)
# Adding different annotation to each facet in ggplot (https://www.r-bloggers.com/2018/11/adding-different-annotation-to-each-facet-in-ggplot/)
#
# Load packages ----
library(tidyverse)
library(httr) # Interact with API
library(jsonlite) # Read API response
library(tidyjson) # Clean json
library(ggplot2)

# Load data ----

# Set parameters
# Start of FEQ: July 6
# End of FEQ: July 17

my_user_agent <- Sys.getenv("WIKIMEDIA_USER_AGENT") # E-mail for API user agent

project <- "fr.wikipedia.org"
access <- "all-access" # all-access, desktop, mobile-app, mobile-web
agent <- "user" # all-agents, user, spider, automated
granularity <- "daily" # daily, monthly
start <- "2022070700" # YYYYMMDDHH
end <- "2022071800" # YYYYMMDDHH

## Create dataframe of articles ----
articles <- data.frame(name = c("Charlotte Cardin",
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
                                   "Half_Moon_Run"),
                       concert_date = as.Date(c("2022-07-06",
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
                                        "2022-07-17")),
                       concert_timezone = "ET")

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
  
  # Convert response to data frame
  response_content_df <- fromJSON(rawToChar(response$content))[["items"]] %>% 
  separate(col = timestamp, c("date", "hour"), sep = 8)
  
  # Add name of artist
  response_content_df$name <- articles$name[i]
  # Clean up date
  response_content_df$date <- as.Date(response_content_df$date, "%Y%m%d")
  # Specify timezone
  response_content_df$timestamp_timezone <- "UTC"
  
  # Combine data frames
  data <- rbind(data, response_content_df)
}

# Tidy data ----

tidy_data <- data %>% 
  # Change column name
  rename(pageviews_date = date) %>% 
  # Add concert date
  left_join(., articles) %>%
  # Correct pageviews date
  mutate(pageviews_date = pageviews_date - 1)

# Create graph ----

graph <- tidy_data %>% 
  ggplot(aes(x = pageviews_date, y = views, group = name), show.legend = FALSE) +
  facet_wrap(~fct_reorder(name, concert_date), ncol = 3) +
  geom_area(aes(fill = name)) +
  viridis::scale_fill_viridis(discrete = TRUE) +
  # Concert date pageviews
  geom_point(data = filter(tidy_data, concert_date == pageviews_date),
             aes(x = concert_date, y = views, group = name),
             size = 0.75) +
  geom_text(data = filter(tidy_data, concert_date == pageviews_date),
            aes(x = concert_date, y = views, label = views),
            nudge_y = 800,
            size = 2) +
  # Labels
  labs(title = "\"Qui joue au FEQ ce soir?\"",
       subtitle = "Pages vues des têtes d'affiches du Festival d'été de Québec
sur fr.wikipedia.org le jour de leur spectacle",
       caption = "Méthodologie: Pages vues quotidiennes tirées de l'API Wikimédia.
       NB: L'article Luke Combs a été créé le 10 juillet 2022.",
       x = "Date", y = "Pages vues") +
  # Set theme
  hrbrthemes::theme_ipsum() +
  theme(
    plot.background = element_rect(fill = "white"),
    legend.position="none",
    panel.spacing = unit(0.1, "lines"),
    strip.text.x = element_text(size = 9),
    plot.title = element_text(size=14),
    axis.text.x = element_text(angle=90, size = 6),
    axis.text.y = element_text(size = 6))

print(graph)

# Save grah

ggsave(
  "graph/wikipedia_pageviews_feq_facet.png",
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
