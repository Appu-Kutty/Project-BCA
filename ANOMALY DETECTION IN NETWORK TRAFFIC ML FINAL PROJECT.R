install.packages(c("tidyverse", "anomalize", "httr"))
# Load necessary libraries
library(tidyverse)
library(anomalize)
library(httr)

# Simulated network traffic data
set.seed(123)
timestamps <- seq.POSIXt(from = as.POSIXct("2023-01-01"), by = "hour", length.out = 1000)
traffic <- rnorm(1000, mean = 100, sd = 10)
traffic[500:505] <- traffic[500:505] + 50  # Injecting anomalies
data <- tibble(timestamp = timestamps, traffic = traffic)

# Plot the data
ggplot(data, aes(x = timestamp, y = traffic)) +
  geom_line() +
  labs(title = "Simulated Network Traffic Data", x = "Time", y = "Traffic")

# Anomaly detection using anomalize
data_anomalized <- data %>%
  time_decompose(traffic, method = "stl") %>%
  anomalize(remainder, method = "iqr") %>%
  time_recompose()

# Plot the anomalies
plot_anomalies(data_anomalized, time_recomposed = TRUE) +
  labs(title = "Anomaly Detection in Network Traffic Data", x = "Time", y = "Traffic")

# Print the anomalies
anomalies <- data_anomalized %>% filter(anomaly == 'Yes')
print(anomalies)
