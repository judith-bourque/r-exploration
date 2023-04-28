library("tidyverse")

# Get tidytuesday data
tuesdata <- tidytuesdayR::tt_load("2023-04-25")

winners <- tuesdata$winners

# Get map data
world_maps <- map_data("world")

# Tidy data ---------------------------------------------------------------

winners_tidy <- janitor::clean_names(winners)

# Analyse data ------------------------------------------------------------

wins_by_nationality <- winners_tidy %>%
  count(nationality)

# Compute the centroid as the mean longitude and lattitude
# Used as label coordinate for country's names
region_lab_data <- world_maps %>%
  group_by(region) %>%
  summarise(longitude = mean(long), latitude = mean(lat))

points <-
  inner_join(wins_by_nationality,
             region_lab_data,
             by = c("nationality" = "region")) %>%
  arrange(desc(n)) %>%
  mutate(
    rank = row_number(),
    colour = case_when(
      rank == "1" ~ "1st place",
      rank == "2" ~ "2nd place",
      rank == "3" ~ "3rd place",
      .default = "other"
    )
  )

labels <- point_data %>% 
  filter(rank <= 3)

# Visualise data ----------------------------------------------------------

colours <-
  c(
    "1st place" = "gold",
    "2nd place" = "#7d7d7d",
    "3rd place" = "brown",
    "other" = "white"
  )

graph <-
  ggplot() +
  borders(fill = "#f7dc99",
          colour = "white",
          size = 0.3) +
  geom_point(
    aes(longitude, latitude, size = n, fill = colour, stroke = 1),
    data = points,
    pch = 21,
    alpha = 0.75
  ) +
  geom_label(aes(longitude, latitude, label = nationality), data = labels, nudge_x = 25) +
  theme_minimal() +
  scale_fill_manual(name = "Ranking", values = colours, aesthetics = c("colour", "fill")) +
  scale_size_identity(guide = "legend", name = "Number of winners") +
  labs(title = "London Marathon Winners by Nationality",
       caption = "Data: Wikipedia via the LondonMarathon R package\nGraphic: github.com/judith-bourque") +
  theme(
    panel.background = element_rect(fill = "lightblue"),
    panel.grid = element_line(colour = "#d1f4ff"),
    plot.background = element_rect(fill = "white")
  )

graph

ggsave(
  "graph/tidytuesday_london_marathon.png",
  width = 10,
  height = 6,
  units = "in"
)

