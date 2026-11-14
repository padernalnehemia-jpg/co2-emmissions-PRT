
# Load raw OWID data
owid_data <- read.csv("data/owid-co2-data.csv")

# Filter for Portugal (PRT) from 1990 to 2024
prt_data <- owid_data[owid_data$iso_code == "PRT" & owid_data$year >= 1990 & owid_data$year <= 2024, c("year", "co2", "co2_per_capita")]
dir.create("data", showWarnings = FALSE)
write.csv(prt_data, "data/PRT_co2.csv", row.names = FALSE)

# Calculate summary metrics
first_row <- prt_data[prt_data$year == 1990, ]
last_row <- prt_data[prt_data$year == 2024, ]
peak_row <- prt_data[which.max(prt_data$co2), ]
endpoint_change <- ((last_row$co2 - first_row$co2) / first_row$co2) * 100

summary_df <- data.frame(
  country = "Portugal",
  iso_code = "PRT",
  first_year = 1990,
  last_year = 2024,
  first_co2_mt = first_row$co2,
  last_co2_mt = last_row$co2,
  endpoint_change_percent = endpoint_change,
  peak_year = peak_row$year,
  peak_co2_mt = peak_row$co2,
  latest_co2_per_capita_t = last_row$co2_per_capita
)

dir.create("results", showWarnings = FALSE)
write.csv(summary_df, "results/PRT_summary.csv", row.names = FALSE)

# Calculate yearly changes
prt_data$co2_change <- c(NA, diff(prt_data$co2))
prt_data$percent_change <- c(NA, (diff(prt_data$co2) / head(prt_data$co2, -1)) * 100)
write.csv(prt_data, "results/PRT_yearly_changes.csv", row.names = FALSE)

# Generate plots
dir.create("figures", showWarnings = FALSE)

png("figures/PRT_annual_co2.png", width = 700, height = 400)
plot(prt_data$year, prt_data$co2, type = "o", col = "forestgreen", pch = 16, lwd = 2,
     main = "Portugal Annual CO2 Emissions (1990-2024)",
     xlab = "Year", ylab = "CO2 Emissions (Million Tonnes)")
grid()
dev.off()

png("figures/PRT_per_capita.png", width = 700, height = 400)
plot(prt_data$year, prt_data$co2_per_capita, type = "o", col = "steelblue", pch = 16, lwd = 2,
     main = "Portugal CO2 Per Capita (1990-2024)",
     xlab = "Year", ylab = "Tonnes Per Person")
grid()
dev.off()

png("figures/PRT_annual_change.png", width = 700, height = 400)
barplot(prt_data$co2_change, names.arg = prt_data$year, col = "indianred", border = NA,
        main = "Portugal Yearly Change in CO2 Emissions",
        xlab = "Year", ylab = "Absolute Change (Million Tonnes)")
grid()
dev.off()

