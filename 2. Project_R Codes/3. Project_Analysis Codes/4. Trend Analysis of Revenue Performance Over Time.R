# ==========================================================================================================

#######   4. Trend Analysis of Revenue Performance Over Time.  #######

# ==========================================================================================================

#-----   I. Project Overview   -----#

#---  Business Challenge:
# The company seeks to understand long-term revenue performance, identifying whether there is a clear upward or
# downward trend over time.By analysing these trends, leadership can assess business growth sustainability, 
# spot early signs of decline, and make strategic decisions to optimize performance.

#---  Project Goal: 
# This project aims to evaluate revenue performance over time, identifying trends to support proactive decision-making, 
# ensure sustained growth, and address potential areas of concern before they impact overall performance.

#-----   II. Key Business Question  -----#

#---  Business Question:
# Is there a clear upward or downward trend in revenue performance over time?

#---  Approach:
# Write R Script to calculate and visualize revenue performance over time.
# Use time series analysis to identify long-term trends, seasonality, and anomalies.
# Create a clear visualization (line charts) to illustrate performance trajectories.
# Provide actionable, data-driven recommendations to capitalize on positive trends and mitigate the impact of declining performance.

# -----------------------------------------------------------------------------

# ------ Grouping Cleaned Sales Data by Year and Month  ------
# Summarizing revenue, profit, and volume data at the monthly level
sales_group <- cleaned_sales_data %>% 
  group_by(year, month) %>%             # Grouping the data by 'year' and 'month'
  summarise(
    sum_revenue = sum(revenue),         # Calculating the total revenue amount for each month
    sum_profit = sum(profit),           # Calculating the total profit for each month
    sum_volume = sum(volume),           # Calculating the total volume sold for each month
    .groups = "drop"                    # Dropping the grouping structure after summarizing to simplify further operations
  )

# ------  Monthly Revenue Analysis: Conversion to Millions and Thousands for Clarity  ------
# Transforming raw values into more interpretable units (millions for revenue and profit, thousands for volume)
sales_group <- sales_group %>% 
  mutate(Revenue_in_M = round(sum_revenue / 1e6, 2)) %>%         # Converting total revenue to millions ($M) and round to 2 decimal places
  mutate(Profit_in_M = round(sum_profit / 1e6, 2)) %>%           # Converting total profit to millions ($M) and round to 2 decimal places
  mutate(Volume_in_K = round(sum_volume / 1e3, 3)) %>%           # Converting total volume to thousands (K) and round to 3 decimal places
  select(month, Revenue_in_M)                                    # Selecting only the 'month' and converted 'Revenue_in_M' columns for output
# Displaying the final grouped and summarized data in an interactive view
view(sales_group)       

# ------  Creating Time Series Data to Analyse Revenue Trends  ------
Revenue_in_M_ts<- ts(sales_group$Revenue_in_M, start = c(2020,10), end = c(2023,12), frequency = 12) 
Revenue_in_M_ts

# ------  Visualizing Monthly Revenue Trends with Time Series Plot  ------
plot(Revenue_in_M_ts, xaxt = "n", xlab = "Year_Month", ylab = "Revenue ($ Millions)", type = "l",
     lwd=2, main = "Total Revenue per Month", col ="red")
abline(h = mean(Revenue_in_M_ts), col = "blue", lty = 2)          # Dashed line at average revenue level
points(Revenue_in_M_ts, pch = 16, col = "steelblue",cex = 0.7)    # Adding points with specific shape and color
grid(col = "gray", lty = "dotted")

# Extracting and Formatting Time Points for Month-Year Labels
time_labels <- time(Revenue_in_M_ts)
month_year_labels <- format(as.Date(paste(floor(time_labels), (time_labels - floor(time_labels)) * 12 + 1, "01", sep="-")), "%b-%Y")

# Adding the x-axis with formatted month-year labels
axis(1, at = time(Revenue_in_M_ts), labels = month_year_labels, las = 2, cex.axis = 0.8)

