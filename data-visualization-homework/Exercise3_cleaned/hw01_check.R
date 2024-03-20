if (!requireNamespace("tidyverse", quietly = TRUE)) {
  install.packages("tidyverse")
}
library(readr)

hcmst_data <- read_rds("/Users/shuaitaotan/Documents/GitHub/course_content2/Exercises/03_dating_GRADED/HCMST_couples.rds")
head(hcmst_data)

#finished importing data

#Question2 
selected_variable <- hcmst_data[, c('ppage', 'ppgender', 'Q9')]
# Replace NA in ppage with its mean
selected_variable$ppage[is.na(selected_variable$ppage)] <- mean(selected_variable$ppage, na.rm = TRUE)
# Replace NA in Q9 with its mean
selected_variable$Q9[is.na(selected_variable$Q9)] <- mean(selected_variable$Q9, na.rm = TRUE)
head(selected_variable, 10)



library(ggplot2)
library(ggalt)
updated_colors <- c("Male" = "#9B59B6",  
                    "Female" = "#F1C40F") 

# Basic scatter plot with points colored by gender
p <- ggplot(selected_variable, aes(x = ppage, y = Q9)) +
  geom_point(aes(color = ppgender), alpha = 0.2) +  
  scale_color_manual(values = updated_colors) +
  labs(title = "Relationship Between Respondent's and Partner's Ages by Gender",
       x = "Respondent's Age",
       y = "Partner's Age",
       color = "Gender") +
  theme_minimal() +
  geom_smooth(method = "lm", se = FALSE, color = "black") +  # Add trend line
  theme(legend.position = "bottom")
# Add annotation
p <- p + annotate("text", x =100 , y = 20, label = "Positive relationship between respondent's age and partner's age regardless of gender", size = 2, hjust = 1, color = "black")
print(p)


#Question 1
"meeting_type" %in% names(hcmst_data)
unique_values <- unique(hcmst_data$meeting_type)
print(unique_values)

columns_to_check <- c("Q21A_Year", "Q21A_Month")
columns_exist <- columns_to_check %in% names(hcmst_data)
print(columns_exist)


library(ggplot2)
library(dplyr)

hcmst_data <- hcmst_data %>%
  mutate(Simplified_Meeting_Type = case_when(
    meeting_type %in% c("Primary or Secondary School", "College") ~ "School/College",
    meeting_type %in% c("Military", "Customer-Client Relationship", "Work Neighbors", "Business Trip", "Work") ~ "Work-Related",
    meeting_type %in% c("Bar or Restaurant", "Public Place", "Blind Date", "Private Party", "On Vacation", "One-time Service Interaction") ~ "Social/Leisure",
    meeting_type %in% c("Internet", "Internet Dating or Phone App", "Internet Social Network", "Online Gaming", "Internet Chat", "Internet Site", "Met Online") ~ "Online",
    TRUE ~ "Other"
  ))
table(hcmst_data$Simplified_Meeting_Type)

# Convert Q21A_Year from factor to numeric and drop rows with NA in Q21A_Year
hcmst_data <- hcmst_data %>%
  mutate(Q21A_Year = as.numeric(as.character(Q21A_Year))) %>%
  filter(!is.na(Q21A_Year)) %>%
  mutate(Year_Interval = 5 * floor((Q21A_Year - 1930) / 5) + 1930)

# Count the frequency of each Simplified_Meeting_Type within each Year_Interval
frequency_data <- hcmst_data %>%
  group_by(Year_Interval, Simplified_Meeting_Type) %>%
  summarise(Frequency = n(), .groups = 'drop')

# Plotting the trend of Simplified_Meeting_Type over the Year_Interval
ggplot(frequency_data, aes(x = Year_Interval, y = Frequency, color = Simplified_Meeting_Type)) +
  geom_line() +
  geom_point() + # Adding points for clarity
  scale_x_continuous(breaks = seq(1930, 2010, by = 10)) + 
  labs(title = "Trend of Meeting Types Over 5-Year Intervals",
       x = "Year Interval",
       y = "Frequency",
       color = "Meeting Type") +
  theme_minimal() + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


#######library(ggplot2)

# Create the bar chart
ggplot(frequency_data, aes(x = factor(Year_Interval), y = Frequency, fill = Simplified_Meeting_Type)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_x_discrete(breaks = seq(1930, 2010, by = 10), labels = seq(1930, 2010, by = 10)) +
  labs(title = "Frequency of Meeting Types Over 5-Year Intervals",
       x = "Year Interval",
       y = "Frequency",
       fill = "Meeting Type") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) # Improve readability of x-axis labels


#

# Print the result
print(hcmst_data$duration)
print(hcmst_data$partyid7)
print(hcmst_data$w6_q12)
# Define the mapping for both variables
level_to_numeric <- c(
  "Strong Republican" = -3, 
  "Not Strong Republican" = -2, 
  "Leans Republican" = -1,
  "Undecided/Independent/Other" = 0, 
  "Leans Democrat" = 1, 
  "Not Strong Democrat" = 2, 
  "Strong Democrat" = 3
)
# Ensure 'partyid7' and 'w6_q12' are factors
hcmst_data$partyid7 <- factor(hcmst_data$partyid7)
hcmst_data$w6_q12 <- factor(hcmst_data$w6_q12)

# Apply the mapping to convert levels to numeric values, excluding levels not in the mapping
hcmst_data$partyid7_numeric <- ifelse(hcmst_data$partyid7 %in% names(level_to_numeric), 
                                      as.numeric(level_to_numeric[as.character(hcmst_data$partyid7)]), 
                                      NA)  # Assign NA to levels not in the mapping

hcmst_data$w6_q12_numeric <- ifelse(hcmst_data$w6_q12 %in% names(level_to_numeric), 
                                    as.numeric(level_to_numeric[as.character(hcmst_data$w6_q12)]), 
                                    NA)  # Assign NA to levels not in the mapping
# Calculate the difference between partyid7_numeric and w6_q12_numeric, ignoring NA values
hcmst_data$difference_numeric <- ifelse(!is.na(hcmst_data$partyid7_numeric) & !is.na(hcmst_data$w6_q12_numeric),
                                        hcmst_data$partyid7_numeric - hcmst_data$w6_q12_numeric,
                                        NA)  # Assign NA where either value is NA
library(ggplot2)
ggplot(hcmst_data, aes(x = difference_numeric, y = duration)) +
  geom_point(alpha = 0.7, color = "#9b59b6", size = 3) +  # Adjust point transparency, color, and size
  theme_minimal(base_size = 14) +  # Use a minimal theme with a larger base font size for readability
  labs(title = "Difference in Political Affiliation vs. Relationship Duration",
       subtitle = "Each point represents a couple, colored by the difference in political affiliation.",
       x = "Difference in Political Affiliation",  # Corrected axis labels for clarity
       y = "Duration")
  theme(plot.title = element_text(face = "bold", size = 20),  # Customize title appearance
        plot.subtitle = element_text(size = 14),  
        axis.title.x = element_text(size = 16),  
        axis.title.y = element_text(size = 16), 
        axis.text.x = element_text(size = 12),  
        axis.text.y = element_text(size = 12))  
  
  ### 
  library(ggplot2)

# Calculate the absolute difference between partyid7_numeric and w6_q12_numeric
hcmst_data$abs_difference_numeric <- abs(hcmst_data$partyid7_numeric - hcmst_data$w6_q12_numeric)
library(ggplot2)

# Create the heatmap using the absolute difference
ggplot(hcmst_data, aes(x = abs_difference_numeric, y = duration)) +
  stat_bin2d(bins = 20, aes(fill = ..count..), color = "#f1c40f") +  
  scale_fill_viridis_c(option = "C", direction = -1, guide = "colorbar") +  # Use a color scale for density
  labs(title = "Heatmap of Relationship Duration vs. Absolute Political Affiliation Difference",
       x = "Absolute Difference in Political Affiliation",
       y = "Duration",
       fill = "Count") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))  

  

 ###Sexual Orientation
print(levels(hcmst_data$Q17C))
# Assign easy numeric values to each level
level_to_numeric_Q17C <- c(
  "Refused" = NA,
  "I am sexually attracted only to men" = 1,
  "I am mostly sexually attracted to men, less often sexually attracted to women" = 2,
  "I am equally sexually attracted to men and women" = 3,
  "I am mostly sexually attracted to women, less often sexually attracted to men" = 4,
  "I am sexually attracted only to women" = 5
)

# Replace the levels with numeric values
hcmst_data$Q17C_numeric <- level_to_numeric_Q17C[hcmst_data$Q17C]

# Print out the levels with their corresponding numeric values
print(hcmst_data$Q17C_numeric)


library(ggplot2)

# Define a custom color palette with less bright colors
my_colors <- c("1" = "#5E4FA2", "2" = "#66C2A5", "3" = "#FC8D62", "4" = "#8DA0CB", "5" = "#E78AC3")

# Create a scatter plot
ggplot(hcmst_data, aes(x = Q17C_numeric, y = duration, color = as.factor(Q17C_numeric))) +
  geom_jitter(width = 0.3, alpha = 0.6) +  # Add jitter to avoid overplotting
  scale_color_manual(values = my_colors) +  # Use custom color palette
  labs(title = "Relationship Duration by Sexual Orientation",
       x = "Sexual Orientation",
       y = "Duration") +
  scale_x_continuous(breaks = 1:5, labels = c("1" = "only to men",
                                              "2" = "mostly to men, less to women",
                                              "3" = "equally",
                                              "4" = "mostly to women, less to men",
                                              "5" = "only to women")) +  # Set x-axis labels
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "bottom",  
        legend.box = "horizontal", 
        legend.key.height = unit(0.5, "cm"),  
        legend.text = element_text(size = 10)) +  
  guides(color = guide_legend(nrow = 2))


###
print(hcmst_data$Q14)
# Check unique levels of the "Q14" variable
unique_levels <- unique(hcmst_data$Q14)
print(unique_levels)

breaks <- c(-Inf, 3, 9, 13, Inf)  # Define breaks to group the levels
labels <- c("Less than High School", "High School Graduate", "Some College", "Bachelor's Degree or Higher")  # Define labels for the new levels
# Create a new variable "parental_education" by grouping levels of "Q14"
hcmst_data$parental_education <- cut(as.integer(hcmst_data$Q14), breaks = breaks, labels = labels, include.lowest = TRUE)
levels(hcmst_data$parental_education)
# Define the mapping from levels to numeric values
level_to_numeric <- c(
  "Less than High School" = 1,
  "High School Graduate" = 2,
  "Some College" = 3,
  "Bachelor's Degree or Higher" = 4
)
# Convert the factor variable "parental_education" to numeric based on the mapping
hcmst_data$parental_education_numeric <- as.numeric(level_to_numeric[as.character(hcmst_data$parental_education)])
library(ggplot2)

ggplot(hcmst_data, aes(x = parental_education_numeric, fill = duration)) +
  geom_histogram(bins = 30, color = "#5E4FA2", fill = "#f1c40f", alpha = 0.5) +  
  geom_density(aes(y = ..count.., group = 1), color = "black", size = 1) + 
  labs(title = "Distribution of Relationship Duration by Parental Education",
       x = "Parental Education Numeric",
       y = "Duration") +
  scale_fill_brewer(palette = "Set1") + 
  theme_minimal() +
  theme(legend.position = "right") 



####
library(ggplot2)
library(plotly)
library(orca)

library(ggplot2)
library(plotly)

# Assuming 'hcmst_data' is your dataframe

gg <- ggplot(hcmst_data, aes(x = parental_education_numeric, fill = duration)) +
  geom_histogram(bins = 10, color = "#5E4FA2", fill = "#f1c40f", alpha = 0.5) +  
  geom_density(aes(y = ..count.., group = 1), color = "black", size = 1) + 
  labs(title = "Distribution of Relationship Duration by Parental Education",
       x = "Parental Education Numeric",
       y = "Duration") +
  scale_fill_brewer(palette = "Set1") + 
  theme_minimal() +
  theme(legend.position = "right")

# Convert ggplot to interactive plotly plot
gg_plotly <- ggplotly(gg)
gg_plotly


install.packages("highcharter")
library(highcharter)

library(highcharter)

library(highcharter)

# Ensure 'duration' is numeric
hcmst_data$duration <- as.numeric(hcmst_data$duration)

# Create an interactive scatter plot with highcharter
hc <- hchart(hcmst_data, "scatter", hcaes(x = difference_numeric, y = duration)) %>%
  hc_plotOptions(scatter = list(marker = list(radius = 5, symbol = "circle", states = list(hover = list(enabled = TRUE, lineWidthPlus = 0))))) %>%
  hc_tooltip(pointFormat = "Duration: {point.y}<br/>Difference: {point.x}") %>%
  hc_xAxis(title = list(text = "Difference in Political Affiliation")) %>%
  hc_yAxis(title = list(text = "Duration")) %>%
  hc_legend(enabled = FALSE)  # Disable legend

hc

#####
install.packages("DT")
library(DT)


library(DT)
head(hcmst_data)
# Select useful variables and rename them
subset_data <- hcmst_data[, c("Q14", "Q17B", "Q19")]
colnames(subset_data) <- c("Mother Education", "Marriage Number", "Living Status")

# Create interactive data table
datatable(
  subset_data,
  options = list(
    pageLength = 10,
    filter = 'top',
    ordering = TRUE
  )
)

path.expand("~")
getwd()


