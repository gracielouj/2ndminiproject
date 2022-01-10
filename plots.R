## Problem 2

library(dplyr) # Load package to deal with data manipulation
library(lubridate) # Load package to deal with dates

# Get data subset
subset <- read.table(
  "specdata/household_power_consumption.txt", 
  header = TRUE, 
  sep = ";",
  na.strings = "?") %>%
  mutate(across(-c("Date":"Time"), as.numeric)) %>%
  mutate(Date = dmy(Date)) %>% 
  filter(Date == "2007-02-01" | Date == "2007-02-02") %>%
  mutate(DateTime = ymd_hms(paste(Date, Time, sep = " ")))


# Plot 1
# Create histogram
plot1 <- function(data) {
  hist(data$Global_active_power, xlab = "Global Active Power (kilowatts)", ylab = "", main = "Global Active Power", col = "red")
}

# Plot 2
plot2 <- function(data){
  plot(data$DateTime, data$Global_active_power, xlab = "", ylab = "Global Active Power (kilowatts)", type = "l",)
}

# Plot 3
plot3 <- function(data){
  plot(data$DateTime,data$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
  lines(data$DateTime, data$Sub_metering_2, col = "red")
  lines(data$DateTime, data$Sub_metering_3, col = "blue")
  legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1, lwd = 1)
}

# Plot 4
plot4 <- function(data){
  par(mfrow = c(2, 2))
  plot2(data)
  plot(data$DateTime, data$Voltage, type = "l", xlab = "", ylab = "Voltage")
  plot3(data)
  plot(data$DateTime, data$Global_reactive_power, xlab = "", ylab = "Global Reactive Power", type = "l")
}

# Create and export the plots in PNG
png("plot1.png")
plot1(subset)
dev.off()
png("plot2.png")
plot2(subset)
dev.off()
png("plot3.png")
plot3(subset)
dev.off()
png("plot4.png")
plot4(subset)
dev.off()