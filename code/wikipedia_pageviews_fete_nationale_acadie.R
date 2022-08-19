# Description -------------------------------------------------------------
#
# This R script creates a graph of Wikipedia pageviews of the article National
# Acadian Day accross all languages.
#
# It was written as part of an experiment with data visualization.
#
# The Wikimedia pageviews timestamps correspond with the end of the recorded
# period in UTC. Dates have been adjusted to reflect the day recorded in UTC.
#
# Date: 2022-08-11
# Author: Judith Bourque (https://github.com/judith-bourque)
#
## Data sources ------------------------------------------------------------
#
# Wikimedia Pageviews (https://dumps.wikimedia.org/other/)
# API documentation (https://wikimedia.org/api/rest_v1/)
#
## Code sources ------------------------------------------------------------
#
# Accessing APIs from R (and a little R programming) (https://www.r-bloggers.com/2015/11/accessing-apis-from-r-and-a-little-r-programming/)
# Adding different annotation to each facet in ggplot (https://www.r-bloggers.com/2018/11/adding-different-annotation-to-each-facet-in-ggplot/)
# Customizing time and date scales in ggplot2 (https://www.r-bloggers.com/2018/06/customizing-time-and-date-scales-in-ggplot2/)
# How to add colors and linetype with ggplot2 (https://community.rstudio.com/t/how-to-add-colors-and-linetype-with-ggplot2/28537)
#
# Load packages -----------------------------------------------------------

library(tidyverse)
library(httr) # Interact with API
library(jsonlite) # Read API response
library(tidyjson) # Clean json
library(ggplot2) # Visualise data
library(ggrepel) # Repel text on ggplot

# Load data ---------------------------------------------------------------

# Set request parameters

my_user_agent <- Sys.getenv("WIKIMEDIA_USER_AGENT") # E-mail for API user agent

access <- "all-access" # all-access, desktop, mobile-app, mobile-web
agent <- "user" # all-agents, user, spider, automated
granularity <- "daily" # daily, monthly
start <- "2022081000" # YYYYMMDDHH
end <- "2022081700" # YYYYMMDDHH

# Create list of articles

title <- c(
  "National_Acadian_Day",
  "Fête_nationale_de_l%27Acadie"
  )

project <- c(
  # Acadie
  "en.wikipedia.org",
  "fr.wikipedia.org"
  )

event_date <- as.Date(c(
  "2022-08-15",
  "2022-08-15"
  ))

articles <- tibble(title, project, event_date)

# Pageviews data

data <- tibble()

for (i in 1:nrow(articles)) {
  # Get response from API
  response <- GET(url = paste("https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article",
                              articles$project[i], access, agent, articles$title[i], granularity,
                              start, end, sep = "/"),
                  user_agent(my_user_agent))
  
  # Convert response to data frame
  response_content_df <- fromJSON(
    # Convert to UTF-8 encoding
    str_conv(
      rawToChar(response$content), "UTF-8"
      )
    )[["items"]] %>% 
    separate(col = timestamp, c("date", "hour"), sep = 8) %>% 
    as_tibble()

  # Clean up date
  response_content_df$date <- as.Date(response_content_df$date, "%Y%m%d")
  # Specify timezone
  response_content_df$timestamp_timezone <- "UTC"
  
  # Combine data frames
  data <- rbind(data, response_content_df)
  
  # Limit to 200 requests per second
  Sys.sleep(0.005)
}

# Tidy data ---------------------------------------------------------------

tidy_data <- data %>% 
  # Change column name
  rename(pageviews_date = date) %>% 
  mutate(
    # Specify article name url
    url = article,
    # Clean article name
    article = gsub("_", " ", article))

# Refine data -------------------------------------------------------------

refined_data <- tidy_data %>% 
  group_by(pageviews_date) %>% 
  summarise(views = sum(views)) %>% 
  mutate(
    language = "total",
    event_date = as.Date("2022-08-15")
    )

refined_data <- tidy_data %>% 
  mutate(language = case_when(project == "fr.wikipedia" ~ "français",
                              project == "en.wikipedia" ~ "anglais"),
         event_date = as.Date("2022-08-15")) %>% 
  select(language, pageviews_date, views, event_date) %>% 
  rbind(refined_data)

# Reorder language

refined_data$language <- factor(refined_data$language, levels=c("total", "anglais", "français"))

# Create graph ------------------------------------------------------------

# By article

graph <- ggplot(refined_data, aes(x = pageviews_date, y = views)) +
  # Add line of data
  geom_line(aes(colour = language, linetype = language)) +
  # Specify colour of lines
  scale_color_manual(values = c("#cc0000", "#cca300", "#0033cc")) +
  # Make concise labels for date
  scale_x_date(labels = scales::label_date_short()) +
  # Event date pageviews
  geom_point(data = filter(refined_data, event_date == pageviews_date),
             aes(x = event_date, y = views),
             size = 0.75) +
  geom_text(data = filter(refined_data, event_date == pageviews_date),
            aes(x = event_date, y = views, label = views),
            nudge_y = 200,
            size = 2) +
  # Add titles
  labs(
    title = "Consultations de l'article Fête nationale de l'Acadie sur Wikipédia",
    caption = "Données: API Wikimédia \nVisualisation: Judith Bourque"
  ) +
  xlab("") +
  ylab("") +
  # Define theme
  theme(
    axis.ticks.x = element_blank(),
    axis.ticks.y = element_blank(),
    axis.line.x.bottom = element_line(colour = "black"),
    legend.position = "top",
    legend.title = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.background = element_rect(fill = "white")
  )

graph

# Save grah

ggsave(
  "graph/wikipedia_pageviews_fete_nationale_acadie.png",
  plot = last_plot(),
  path = NULL,
  scale = 1,
  width = 8,
  height = 4.5,
  units = "in",
  dpi = 300,
  limitsize = TRUE,
  bg = NULL
)
