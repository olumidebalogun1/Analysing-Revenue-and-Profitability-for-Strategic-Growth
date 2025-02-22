# ==========================================================================================================

#######   1. Annual Revenue, Profit, and Volume Performance with Percentage Growth.   #######

# ==========================================================================================================

#-----   I. Project Overview   -----#

#---  Business Challenge:
# The company seeks to understand its annual revenue, profit, and volume performance over time,
# identifying whether any years experienced negative or stagnant growth. By pinpointing periods
# of under performance or stagnation and assessing the significance of variations in key metrics,
# leadership can proactively address potential weaknesses and capitalize on growth opportunities.

#---   Project Goal:
# This project aims to evaluate annual revenue, profit, and volume performance with percentage growth.
# The insights gained will support strategic decisions to address periods of under performance,
# detect trends,and guide corrective action for sustainable business growth.

#-----   II. Key Business Question  -----#

#---  Business Question:
# Did any years experience negative or stagnant growth? Furthermore, are there significant differences in the data?

#---   Approach:
# Write R Script to calculate annual revenue, profit, and volume, along with year-over-year percentage growth.
# Identify years of negative or stagnant growth and assess the magnitude of these variations.
# Create a clear visualization to illustrate annual performance trends and discrepancies.
# Provide actionable, data-driven recommendations to mitigate periods of underperformance and enhance strategic planning.

# -------------------------------------------------------------------------------------------

# loading necessary libraries
library(RColorBrewer)
library(gtExtras)

# ------  Calculating the Annual Total Revenue , Profit, and Volume Summary  -------
# Grouping the Cleaned Sales Data by year and computing the annual aggregates for revenue, profit, and volume
Annual_Summary <- cleaned_sales_data %>%
  group_by(year) %>%      # Grouping the dataset by the 'year' column
  summarise(
    Total_Revenue = round(sum(revenue) / 1e6, 2),      # Calculating total revenue in millions ($M), rounded to 2 decimal places
    Total_Profit = round(sum(profit) / 1e6, 2),        # Calculating total profit in millions ($M), rounded to 2 decimal places
    Total_Volume = round(sum(volume) / 1e3, 2)         # Calculating total volume in thousands (K), rounded to 2 decimal places
  )

# -------  Analysing Annual Performance with Revenue, Profit, and Volume Growth  ------
Annual_Summary <- Annual_Summary %>%
  arrange(year) %>%
  mutate(
    Pct_diff_Revenue = paste0(round((Total_Revenue  - lag(Total_Revenue )) / lag(Total_Revenue ) * 100, 2), "%"),
    Pct_diff_Profit = paste0(round((Total_Profit  - lag(Total_Profit))  / lag(Total_Profit ) * 100, 2), "%"),
    Pct_diff_Volume = paste0(round((Total_Volume  - lag(Total_Volume))  / lag(Total_Volume)  * 100, 2), "%")
  )

# ------  Visualizing Annual Revenue , Profit, and Volume Performance with Growth Trends  ------
# Creating table to display annual performance metrics and growth trends
Plot_Annual_Summary <- Annual_Summary %>% 
  gt() %>% 
  tab_header(title = "Annual Performance: Revenue ($ Million), Profit ($ Million), 
             and Volume (Thousand) with Percentage Growth") %>%          # Adding descriptive title to the table
  cols_align(align = "left")                                             # Aligning all columns to the left for better readability
Plot_Annual_Summary          # Displaying the basic visualization table

# ------  Highlighting Key Data Points with Conditional Formatting  ------
# Enhancing the table visualization by applying themes and highlighting important data points
plot_annual_performance <- Plot_Annual_Summary %>% 
  gt_theme_pff() %>%                                                        # Applying professional theme for consistent styling
  gt_highlight_rows(column = Total_Revenue, fill="lightpink") %>%           # Highlighting cells in the "Total Revenue" column with light pink
  gt_highlight_rows(column = Total_Profit, fill="lightblue") %>%            # Highlighting cells in the "Total Profit" column with light blue
  gt_highlight_rows(column = Pct_diff_Revenue, fill="lightpink") %>%        # Highlighting cells in "Revenue Growth %" column with light pink
  gt_highlight_rows(column = Pct_diff_Profit, fill="lightblue") %>%         # Highlighting cells in "Profit Growth %" column with light blue
  gt_highlight_rows(rows = Pct_diff_Revenue < 0, fill="steelblue")          # Highlighting rows where revenue growth is negative with steel blue

plot_annual_performance        # Displaying the final formatted table with conditional formatting 

