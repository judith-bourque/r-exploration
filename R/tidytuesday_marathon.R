library("tidyverse")

# Get tidyverse data
tuesdata <- tidytuesdayR::tt_load('2023-04-25')

winners <- tuesdata$winners

# Get map data
world_maps <- map_data("world")

# Tidy data ---------------------------------------------------------------

winners_tidy <- janitor::clean_names(winners)

# Analyse data ------------------------------------------------------------

data <- winners_tidy %>% 
  count(nationality)

# Compute the centroid as the mean longitude and lattitude
# Used as label coordinate for country's names
region_lab_data <- world_maps %>%
  filter(region %in% winners_tidy$nationality) %>%
  group_by(region) %>%
  summarise(longitude = mean(long), latitude = mean(lat))

# Visualise data ----------------------------------------------------------

graph <-
  ggplot() +
  borders(
    fill = "lightgrey",
    colour = "white"
  ) +
  geom_point(alpha = 0.5) +
  theme_void() +
  ggrepel::geom_text_repel(
    data = region_lab_data,
    aes(longitude, latitude, label = region),
    size = 3,
    colour = "black"
  ) +
  scale_color_manual(values = colours) +
  labs(title = "Title",
       colour = "",
       caption = "Data:Source\nGraphic: github.com/judith-bourque") +
  theme(
    legend.position = "top",
    plot.title = element_text(hjust = 0.5),
    plot.background = element_rect(fill = "white"),
    plot.caption = element_text(hjust = 0.5, margin = margin(b = 5))
  )

graph
