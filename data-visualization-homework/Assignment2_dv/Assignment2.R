#Assignment 2

library(readr)
storms_data <- read.csv("/Users/shuaitaotan/Documents/GitHub/course_content2/Exercises/07_severe_weather_GRADED/data/storms.csv")


######Question 1 Graph 1
library(dplyr)
library(ggplot2)
library(maps)
library(sf)

#### DATA Modification
damage_data <- storms_data %>%
  group_by(STATE) %>%
  summarise(Total_Damage = sum(DAMAGE_PROPERTY_USD, na.rm = TRUE) + sum(DAMAGE_CROPS_USD, na.rm = TRUE))
head(damage_data)
us_states <- st_as_sf(maps::map("state", plot = FALSE, fill = TRUE))
head(us_states)

# Convert the 'ID' column in 'us_states' to uppercase
us_states$ID <- toupper(us_states$ID)
# Merge the dataset again
merged_data <- merge(us_states, damage_data, by.x = "ID", by.y = "STATE")
head(merged_data)

ggplot(data = merged_data) +
  geom_sf(aes(fill = Total_Damage), color = "WHITE", size = 0.25) + 
  scale_fill_viridis_c() +
  labs(title = "Total Monetary Damage by State",
       fill = "Total Damage") +
  theme_minimal()
######### Better version
ggplot(data = merged_data) +
  geom_sf(aes(fill = Total_Damage), color = "WHITE", size = 0.25) + 
  scale_fill_viridis_c(option = "magma", direction = -1) +
  labs(title = "Total Monetary Damage by State",
       fill = "Total Damage") +
  geom_sf_text(aes(label = ID), size = 1, check_overlap = TRUE, color = "black") +
  theme_void() +
  theme(legend.position = "right",
        plot.title = element_text(hjust = 0.5),
        legend.title.align = 0.5) +
  guides(fill = guide_colorbar(title.position = "top", title.hjust = 0.5))

#####Question 1 Graph 2 county level
# Aggregating damage data at the county level
county_damage_data <- storms_data %>%
  filter(CZ_TYPE == "C") %>% # Focus on county-level events
  group_by(CZ_NAME) %>% # Group by county FIPS code
  summarise(Total_Damage = sum(DAMAGE_PROPERTY_USD, na.rm = TRUE) + sum(DAMAGE_CROPS_USD, na.rm = TRUE))
head(county_damage_data)
# tigris
# Load the tigris package
library(tigris)
options(tigris_use_cache = TRUE)
us_counties <- counties(year = 2020, class = "sf", resolution = "20m")
head(us_counties)
#
us_counties <- us_counties %>%
  mutate(NAME = toupper(NAME))
# Merge us_counties with county_damage_data
new_merge_county_data <- us_counties %>%
  left_join(county_damage_data, by = c("NAME" = "CZ_NAME"))
# Check the first few rows of the merged dataset
head(new_merge_county_data)

####
library(ggplot2)

# Create the choropleth map
ggplot(data = new_merge_county_data) +
  geom_sf(aes(fill = Total_Damage), color = "white", size = 0.1) + 
  scale_fill_viridis_c(name = "Total Damage ($)", option = "plasma", 
                       na.value = "lightgrey", labels = scales::comma) +
  labs(title = "Monetary Damage by County in the USA") +
  theme_minimal() +
  theme(legend.position = "right",
        plot.title = element_text(hjust = 0.5)) +
  coord_sf(xlim = c(-125, -66), ylim = c(24, 50), expand = FALSE)



###### Question 1 Graph 3
state_deaths_data <- storms_data %>%
  group_by(STATE) %>%
  summarise(Total_Deaths = sum(DEATHS_DIRECT, na.rm = TRUE) + sum(DEATHS_INDIRECT, na.rm = TRUE))
head(state_deaths_data)

total_deaths_national <- sum(state_deaths_data$Total_Deaths, na.rm = TRUE)
us_states <- st_as_sf(maps::map("state", plot = FALSE, fill = TRUE))
us_states$ID <- toupper(us_states$ID)
merged_data2 <- merge(us_states, state_deaths_data, by.x = "ID", by.y = "STATE")
merged_data2 <- mutate(merged_data2, Proportion_Deaths = Total_Deaths / total_deaths_national)
head(merged_data2)

####
library(ggplot2)

ggplot(data = merged_data2) +
  geom_sf(aes(fill = Proportion_Deaths), color = "white", size = 0.2) + 
  scale_fill_viridis_c(
    name = "Proportion of Total Deaths",
    labels = scales::percent_format(accuracy = 1),
    na.value = "lightgrey" # For states with no data
  ) +
  labs(title = "Proportion of Total Storm-Related Deaths by State") +
  geom_sf_text(aes(label = ID), size = 1.5, color = "white", check_overlap = TRUE) +
  theme_minimal() +
  coord_sf(xlim = c(-125, -66), ylim = c(24, 50), expand = FALSE) 




#### Question 2 Graph 1
severe_events <- storms_data %>%
  filter((DEATHS_DIRECT > 0 | DEATHS_INDIRECT > 0) & !is.na(BEGIN_LAT) & !is.na(BEGIN_LON))

severe_events <- severe_events %>%
  mutate(Popup_Info = paste(EVENT_TYPE, 
                            "<br>Direct Deaths:", DEATHS_DIRECT,
                            "<br>Indirect Deaths:", DEATHS_INDIRECT,
                            "<br>Start:", BEGIN_DATE_TIME,
                            "<br>End:", END_DATE_TIME))

leaflet(data = severe_events) %>%
  addTiles() %>%
  addMarkers(lng = ~BEGIN_LON, lat = ~BEGIN_LAT, popup = ~Popup_Info) %>%
  addProviderTiles(providers$Esri.WorldImagery) %>%
  setView(lng = -98.583333, lat = 39.833333, zoom = 4) 


###################################################################
severe_events <- storms_data %>%
  filter(DEATHS_DIRECT > 0 | DEATHS_INDIRECT > 0) %>%
  filter(BEGIN_LAT >= 24.396308 & BEGIN_LAT <= 49.384358 & BEGIN_LON >= -125.0 & BEGIN_LON <= -66.93457)


color_palette <- c(
  "Thunderstorm Wind" = "yellow",
  "Tornado" = "white",
  "Hail" = "blue",
  "Flood" = "red",
  # Add more colors for other event types if needed
  "Others" = "gray"  # For any other event types
)

# Redefine the function to handle vectors
map_event_to_color <- function(event_type) {
  ifelse(event_type %in% names(color_palette), color_palette[event_type], color_palette[["Others"]])
}


severe_events <- severe_events %>%
  mutate(Color = map_event_to_color(EVENT_TYPE))

# Create popup information for each marker
severe_events$Popup_Info <- paste(
  "Event Type:", severe_events$EVENT_TYPE,
  "<br>Direct Deaths:", severe_events$DEATHS_DIRECT,
  "<br>Indirect Deaths:", severe_events$DEATHS_INDIRECT,
  "<br>Start:", severe_events$BEGIN_DATE_TIME,
  "<br>End:", severe_events$END_DATE_TIME,
  sep = " "
)

# Create
leaflet(data = severe_events) %>%
  addTiles() %>%
  addCircleMarkers(
    lng = ~BEGIN_LON,
    lat = ~BEGIN_LAT,
    color = ~Color,
    popup = ~Popup_Info,
    fillOpacity = 0.5,
    radius = 5
  ) %>%
  addProviderTiles(providers$Esri.WorldImagery) %>%
  setView(lng = -98.583333, lat = 39.833333, zoom = 4)
##############################################################################

library(leaflet)
library(leaflet.extras)
library(dplyr) 

severe_events <- storms_data %>%
  filter(DEATHS_DIRECT > 0 | DEATHS_INDIRECT > 0) %>%
  filter(BEGIN_LAT >= 24.396308 & BEGIN_LAT <= 49.384358 & BEGIN_LON >= -125.0 & BEGIN_LON <= -66.93457)


color_palette <- c(
  "Thunderstorm Wind" = "yellow",
  "Tornado" = "white",
  "Hail" = "blue",
  "Flood" = "red",
  "Others" = "gray"  # For any other event types
)

# Function to map event types to colors
map_event_to_color <- function(event_type) {
  ifelse(event_type %in% names(color_palette), color_palette[event_type], color_palette[["Others"]])
}

# Assign colors based on event type
severe_events <- severe_events %>%
  mutate(Color = map_event_to_color(EVENT_TYPE))

# Create popup information for each marker
severe_events$Popup_Info <- paste(
  "Event Type:", severe_events$EVENT_TYPE,
  "<br>Direct Deaths:", severe_events$DEATHS_DIRECT,
  "<br>Indirect Deaths:", severe_events$DEATHS_INDIRECT,
  "<br>Start:", severe_events$BEGIN_DATE_TIME,
  "<br>End:", severe_events$END_DATE_TIME,
  sep = " "
)


m <- leaflet(data = severe_events) %>%
  addTiles() %>%
  addCircleMarkers(
    lng = ~BEGIN_LON,
    lat = ~BEGIN_LAT,
    color = ~Color,
    popup = ~Popup_Info,
    fillOpacity = 0.5,
    radius = 5,
    clusterOptions = markerClusterOptions() 
  ) %>%
  addProviderTiles(providers$Esri.WorldImagery) %>%
  setView(lng = -98.583333, lat = 39.833333, zoom = 4)


m





