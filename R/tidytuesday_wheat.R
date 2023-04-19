# Tutorial for adding country labels
# https://www.datanovia.com/en/blog/how-to-create-a-map-using-ggplot2/

library("tidyverse")

# Get tidyverse data
tuesdata <- tidytuesdayR::tt_load('2023-04-18')

founder_crops <- tuesdata$founder_crops

# Filter data
data <- founder_crops %>%
  select(latitude, longitude, founder_crop) %>%
  drop_na() %>%
  filter(founder_crop == "emmer wheat" |
           founder_crop == "einkorn wheat")

min_long <- min(data$longitude)
max_long <- max(data$longitude)
min_lat <- min(data$latitude)
max_lat <- max(data$latitude)

xlim <- c(min_long, max_long)
ylim <- c(min_lat, max_lat)

# Retrieve the map data
world_maps <- map_data("world")

countries <- world_maps %>%
  filter(long > min_long &
           long < max_long & lat > min_lat & lat < max_lat) %>%
  select(region) %>%
  unique()

# Compute the centroid as the mean longitude and lattitude
# Used as label coordinate for country's names
region_lab_data <- world_maps %>%
  filter(region %in% countries$region) %>%
  group_by(region) %>%
  summarise(longitude = mean(long), latitude = mean(lat))

colours <-
  c("emmer wheat" = "#a88e59",
    "einkorn wheat" = "forestgreen")

graph <-
  ggplot(data, aes(longitude, latitude, colour = founder_crop)) +
  borders(
    xlim = xlim,
    ylim = ylim,
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
  labs(title = "Wheat farmed during the Neolithic period in southwest Asia",
       colour = "",
       caption = "Data: The \"Neolithic Founder Crops\" in Southwest Asia: Research Compendium\nGraphic: github.com/judith-bourque") +
  theme(
    legend.position = "top",
    plot.title = element_text(hjust = 0.5),
    plot.background = element_rect(fill = "white"),
    plot.caption = element_text(hjust = 0.5, margin = margin(b = 5))
  )

graph

ggsave(
  "graph/tidytuesday_wheat.png",
  width = 6,
  height = 6,
  units = "in"
)
