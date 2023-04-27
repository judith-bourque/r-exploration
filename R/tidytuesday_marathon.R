library("tidyverse")

# Get tidyverse data
tuesdata <- tidytuesdayR::tt_load('2023-04-25')

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

point_data <- inner_join(wins_by_nationality, region_lab_data, by = c("nationality" = "region")) %>% 
  arrange(desc(n)) %>% 
  mutate(rank = row_number(),
         colour = case_when(rank == "1" ~ "gold",
                            rank == "2" ~ "grey",
                            rank == "3" ~ "brown",
                            .default = "white"
                            ))

# Visualise data ----------------------------------------------------------

colours <-
  c("gold" = "gold",
    "grey" = "grey",
    "brown" = "brown",
    "white" = "white")

graph <-
  ggplot() +
  borders(
    fill = "lightgrey",
    colour = "white"
  ) +
  geom_point(aes(longitude, latitude, size = n, colour = colour), data = point_data, alpha = 0.5) +
  #geom_text(aes(longitude, latitude, label = nationality), top_5) +
  theme_void() +
  scale_color_manual(values = colours) +
  labs(title = "Title",
       colour = "",
       caption = "Data:Source\nGraphic: github.com/judith-bourque") +
  theme(
    legend.position = "top",
    plot.title = element_text(hjust = 0.8),
    plot.background = element_rect(fill = "white"),
    plot.caption = element_text(hjust = 0.5, margin = margin(b = 5))
  )

graph
