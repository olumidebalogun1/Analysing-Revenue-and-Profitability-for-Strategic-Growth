# ---------------------------------------------------------------------------------------------------------------------

# Script Title: Analysing Revenue and Profitability for Strategic Growth
# Author: Olumide Balogun
# Date: 2024-09-22
# The Business Challenge – Why This Project Matters:
#                          In a competitive market, the company struggles to optimize revenue, profitability,
#                          and market performance. Without a data-driven approach, inefficiencies persist,
#                          growth opportunities are missed, and financial sustainability is at risk.

#                          A comprehensive analysis of revenue trends, profitability, customer segmentation,
#                          product performance, pricing, and market variations is crucial to identifying 
#                          top-performing segments, addressing revenue declines, and refining strategies. Without 
#                          analytical visibility,leadership risks resource misallocation and stagnation.

#                          To bridge performance gaps, the company must implement a robust analytical framework
#                          that delivers actionable insights, enhances efficiency, and strengthens competitive
#                          positioning. Leveraging advanced data analytics will empower leadership to drive growth,
#                          improve financial outcomes, and ensure long-term profitability.

# ----------------------------------------------------------------------------------------------------------------------

#######   Loading necessary libraries   #######

library(tidyverse)
library(ggplot2)
library(readxl)
library(lubridate)

# ------ Importing datasets  -----

Sales_Transactions <- read_excel("Revunue Dataset/Sales _Transactions.xlsx")
View(Sales_Transactions)        

Sales_Customers <- read_excel("Revunue Dataset/Sales_Customers.xlsx")
View(Sales_Customers)        

Sales_Markets <- read_excel("Revunue Dataset/Sales_Markets.xlsx")
View(Sales_Markets)        

Sales_products <-read_excel("Revunue Dataset/Sales_products.xlsx")
View(Sales_products)       

#-----  Joining the tables   -----#

sales_data <- Sales_Transactions %>%
  left_join(Sales_Customers, by = "customer_code") %>%
  left_join(Sales_Markets, by = "market_code") %>%
  left_join(Sales_products, by = "product_code")    # Performing simultaneous left joins 
view(sales_data )       


                         #######   Data Cleaning   #######
# Checking for Missing Data
total_missing_values <- sum(is.na(sales_data))
print(paste("Total missing values in the dataset:", total_missing_values))

# Removing missing data
sales_data <- sales_data %>% 
  na.omit(sales_data)

sum(is.na(sales_data))    # Checking for missing data again

# Removing duplicate rows
sales_data <- sales_data %>% 
  distinct()

# Checking the structure of the dataset
str(sales_data)           # Displaying columns, data types, and sample values

# -----  Updating Column Names: Renaming sales_amount to revenue and sales_qty to volume   -----  
# to enhance clarity, consistency, and alignment with business terminology standards. 
sales_data <- sales_data %>%
  rename(
    markets_state = markets_name,    # Rename market_name to markets_state
    revenue = sales_amount,          # Rename sales_amount to revenue
    volume = sales_qty               # Rename sales_qty to volume
  )

head(sales_data)              # View the updated data frame to confirm changes

# -----  Converting order_date to date format and extract year/month.  -----
sales_data$order_date <- as.Date(sales_data$order_date, format = "%Y-%m-%d")      # Converting order_date to Date format
sales_data$year <- format(sales_data$order_date, "%Y")       # Extracting Year
sales_data$month <- format(sales_data$order_date, "%Y-%m")        # Extracting Year and Month

# Displaying columns, data types, and sample values
str(sales_data)   

# -----  Calculating and displaying the number of rows and columns in sales_data.  ----- 
# Number of Rows
num_rows <- nrow(sales_data)
print(paste("Number of rows:", num_rows))

# Number of Columns
num_columns <- ncol(sales_data)
print(paste("Number of columns:", num_columns))

# Combined Information
print(paste("The Sales_dataset has", num_rows, "rows and",num_columns , "columns."))

       #######  Exploratory Data Analysis 1 (EDA) - statistical summary.  ####### 

# -----  Generating a statistical summary for specific columns in sales_data.  -----
# Columns to Summarize
selected_columns <- c("volume", "revenue", "cost_price", "profit", "profit_margin")

# Viewing Summary of Selected Columns
sales_data %>%
  select(all_of(selected_columns)) %>%
  summary()


                 #######  Data Wrangling (Removing Outliers).  #######
# ------------------------------------------------------------------------------
# TASK: To Remove Outliers and Summarize the Cleaned Data.

# Purpose: Outliers are data points significantly different from others,
#          and they can distort statistical measures such as mean and 
#          standard deviation. Removing them helps:
#          1. Improve model accuracy.
#          2. Ensure reliable insights.
#          3. Maintain the integrity of predictions and trends.
# ------------------------------------------------------------------------------

# Removing Outliers and Summarizing Cleaned Data
# Function to Directly Remove Outliers from Original Columns
remove_multi_outliers <- function(sales_data, columns) {
  sales_data %>%
    filter(if_all(
      all_of(columns),
      ~ . >= quantile(., 0.25, na.rm = TRUE) - 1.5 * IQR(., na.rm = TRUE) & 
        . <= quantile(., 0.75, na.rm = TRUE) + 1.5 * IQR(., na.rm = TRUE)
    ))
}

# Columns to Remove Outliers From
columns_to_clean <- c("volume", "revenue", "cost_price", "profit", "profit_margin")

# Applying the Function
cleaned_sales_data <- remove_multi_outliers(sales_data, columns_to_clean)

# Viewing Summary of Selected Columns
cleaned_sales_data %>%
  select(all_of(columns_to_clean)) %>%
  summary()

# -----   Calculating and Displaying the number of Rows and columns After Cleaning.  -----
# Number of Rows
num_rows <- nrow(cleaned_sales_data)
print(paste("Number of rows:", num_rows))

# Number of Columns
num_columns <- ncol(cleaned_sales_data)
print(paste("Number of columns:", num_columns))

# Combined Information
print(paste("The Cleaned_Sales_dataset has", num_rows, "rows and", num_columns, "columns."))

# -----  Calculating and Displaying the Reduction in Rows After Cleaning. -----
# To determine the difference in the number of rows before and after outlier removal.
# Number of Rows in the Original Dataset
num_rows_original <- nrow(sales_data)

# Number of Rows in the Cleaned Dataset
num_rows_cleaned <- nrow(cleaned_sales_data)

# Calculate the Difference
rows_removed <- num_rows_original - num_rows_cleaned

# Display the Result
print(paste("The original dataset had", num_rows_original, "rows."))
print(paste("After removing outliers, the dataset has", num_rows_cleaned, "rows."))
print(paste("The number of rows removed from the dataset is", rows_removed, "."))

                  #######  Exploratory Data Analysis 2 (EDA). ####### 

# Generating a statistical summary for specific columns in cleaned_sales_data.
# Columns to Summarize
selected_columns_csd <- c("volume", "revenue", "cost_price", "profit", "profit_margin")

# Viewing Summary of Selected Columns
cleaned_sales_data %>%
  select(all_of(selected_columns_csd)) %>%
  summary()


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


#=========================================================================================================================================

#######  2. Analysing Top 20 Performers by Customer Type, Product Type, and Market Zone: Revenue and Profitability Analysis.  ######

# ========================================================================================================================================

#-----   I. Project Overview  -----#

#---  Business Challenge: 
# The company seeks to identify its highest-performing customer types, product types, and market zones based on total revenue, 
# highlighting the top 20 performers surpassing $4.00 million. By understanding these key success factors,
# leadership can strategically prioritize resources, optimize growth strategies, and uncover areas for targeted expansion.

#---  Project Goal: 
# This project aims to evaluate revenue and profitability across customer types, product types, and market zones,
# identifying the top 20 performers and enabling informed, strategic decisions to drive growth and maximize business impact.

#-----   II. Key Business Question   -----#

#---  Business Question:
# Which customer types, product types, and market zones rank among the top 20 with total revenue surpassing $4.00 million?
  
#---  Approach:
# Write R Script to calculate total revenue and profitability by customer type, product type, and market zone.
# Filter and rank the top 20 performers in each category, ensuring revenue exceeds $4.00 million.
# Create a clear visualization  to highlight top-performing segments and zones.
# Provide actionable, data-driven recommendations to capitalize on high-performing areas and inform strategic expansion initiatives.

# ------------------------------------------------------------------------------------
 
# -------  Summarizing Total Profit and Revenue by Category  ------
summarized_sales_1 <- cleaned_sales_data%>%
  group_by(customer_type, product_type, markets_zone) %>%
  summarise(
    Total_Profit_in_M = round( sum(profit)/ 1e6, 2),
    Total_Revenue_in_M = round( sum(revenue)/ 1e6, 2), 
    .groups = "drop" ) %>%              # to avoid keeping grouped structure
  arrange(desc(Total_Revenue_in_M))

# ------  Ranking Top 20 Records Based on Total Revenue  ------
revenue_top_20 <- summarized_sales_1 %>%
  slice_max(Total_Revenue_in_M , n = 20)       # Extracting Insights from Top 20 Revenue Performers from summarized_sales_1 

# ------  Visualizing Top Twenty by Total Revenue  ------
# Creating table visualization for the top 20 performers by Total Revenue
plot_revenue <- revenue_top_20 %>% 
  gt() %>% 
  tab_header(title = "Top Twenty (20) by Total Revenue ($ Million)") %>%         # Adding  title to the table
  cols_align(align = "left")     # Aligning all columns to the left for better readability

# ------  Highlighting Key Data Points with Conditional Formatting  ------
# Applying custom theme and highlight specific rows and columns with colors for better emphasis
revenue_domain <- range(summarized_sales_1$Total_Revenue_in_M)          # Extracting the observed range for Total_Revenue_in_M from summarized_sales_1

plot_revenue <- plot_revenue %>% 
  gt_theme_pff() %>%          # Applying pre-defined professional theme to the table
  gt_highlight_rows(rows = Total_Revenue_in_M >= 4.00, fill="lightpink") %>%     # Highlighting rows where Total Revenue >= 90 with light pink color
  gt_color_rows(columns = "Total_Revenue_in_M", palette = "Pastel1",             # Adding pastel color gradient to the "Total Revenue" column for better visual impact
                domain = revenue_domain               # Specifying domain for consistent color scaling
  )
plot_revenue        # Displaying the final formatted table with conditional formatting


# ========================================================================================================================================

#######   3. Analysing Top 20 Performers by Customer Type, Product Type, and Market Zone: Profit and Revenue Insights.  #######

# ========================================================================================================================================

#-----   I. Project Overview  -----#

#---  Business Challenge: 
# The company seeks to identify the most profitable customer types, product types, and market zones,
# highlighting the top 20 performers with total profits exceeding $0.06 million. By understanding where
# significant profit originates, leadership can optimize resource allocation, evaluate the relationship
# between sales and profitability, and drive sustainable growth.

#---  Project Goal: 
# This project aims to evaluate profit and revenue insights across customer types, product types, and market zones,
# identifying the top 20 performers and enabling informed, strategic decisions to maximize profitability and business impact.

#-----   II. Key Business Question  -----#

#---  Business Question:
# Which customer types, product types, and market zones rank among the top 20 with total profits exceeding $0.06 million?

#---  Approach:
# Write R Script to calculate total profit and revenue by customer type, product type, and market zone.
# Filter and rank the top 20 performers in each category, ensuring profits exceed $0.06 million.
# Create a clear visualization to highlight top-performing segments and zones.
# Provide actionable, data-driven recommendations to capitalize on high-profit areas and inform strategic expansion initiatives

# -------------------------------------------------------------------------------------------

# ------  Summarizing Total Revenue and Profit by Category  -------
summarized_sales_2 <- cleaned_sales_data%>%
  group_by(customer_type, product_type, markets_zone) %>%
  summarise(
    Total_Revenue_in_M = round( sum(revenue)/ 1e6, 2), 
    Total_Profit_in_M = round( sum(profit)/ 1e6, 2), 
    .groups = "drop" ) %>%              # to avoid keeping grouped structure
  arrange(desc(Total_Revenue_in_M))

# -------  Ranking Top 20 Records Based on Total Profit  ------
top_20_profit <- summarized_sales_2 %>%
  arrange(desc(Total_Profit_in_M)) %>% 
  slice_max(Total_Profit_in_M, n = 20)       #  Extracting Insights from Top 20 Profit Performers from summarized_sales_2

# ------  Visualizing Top Twenty by Profit  ------
# Creating table visualization for the top 20 performers by profit
plot_profit <- top_20_profit %>% 
  gt() %>% 
  tab_header(title = "Top Twenty (20) by Total Profit ($ Million)") %>%     # Adding title to indicate the table represents top 20 profits
  cols_align(align = "left")      # Aligning columns to the left for better readability

# ------  Highlighting Key Data Points with Conditional Formatting  ------
# Applying custom theme and highlight specific rows and columns for visual emphasis
revenue_domain <- range(summarized_sales_2$Total_Profit_in_M)      # Extracting the observed range for Total_Profit_in_M from summarized_sales_2

plot_profit <- plot_profit %>% 
  gt_theme_pff() %>%     # Applying professional table theme for consistent styling
  gt_highlight_rows(rows = Total_Profit_in_M >= 0.06, fill="lightblue") %>%    # Highlighting rows where Total Profit is >= $1M with light blue
  gt_color_rows(columns = "Total_Profit_in_M", palette = "Pastel1",            # Adding pastel color gradient to the "Total Profit" column for better visualization
                domain = revenue_domain               # Specifying domain for consistent color scaling
  )
plot_profit      # Displaying the final formatted table with conditional formatting


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
view(sales_group)            # Displaying the final grouped and summarized data in an interactive view      

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


# ==========================================================================================================

#######   5. Market Zone Performance Analysis.   #######

# ==========================================================================================================

#----   I. Project Overview  -----#

#---  Business Challenge:
# The company seeks to compare revenue and profitability across various market zones, identifying both high-performing
# and under performing zones. By understanding these differences, leadership can optimize resource allocation, marketing strategies,
# and sales efforts to drive business growth and enhance overall profitability.

#---  Project Goal: 
# This project aims to evaluate revenue and profitability performance across different market zones,
# providing actionable insights to support strategic decision-making and optimize business operations.

#-----   II. Key Business Question  -----#

#---  Business Question:
# How do revenue and profitability differ across various market zones?

#---  Approach:
# Write R Script to calculate and compare revenue and profitability metrics by market zone.
# Identify high-performing and under-performing zones based on revenue and profit margins.
# Perform statistical significance tests to assess differences in key financial metrics.
# Create clear visualizations (bar charts) to highlight performance patterns across market zones.
# Provide actionable, data-driven recommendations to capitalize on strengths, address inefficiencies, and guide targeted business growth initiatives.

# ----------------------------------------------------------------------------------------------------------------------------------

# loading necessary libraries
library(patchwork)
library(ggprism)

#  Revenue and Profit by Market Zone
zone_performance <- cleaned_sales_data %>%
  group_by(markets_zone) %>%        # Grouping the data by 'markets_zone' to analyze performance across different zones
  summarise(total_revenue_in_M = round((sum(revenue))/ 1e6, 2),    # Calculating total revenue in millions and rounding to 2 decimal places
            total_profit_in_M = round((sum(profit))/ 1e6, 2))      # Calculating total profit in millions and rounding to 2 decimal places

#-----   5a.  Evaluation of Revenue Across Market Zone.  -----#

# ------  Bar plot of total revenue by Market Zone  ------
r_m <- ggplot(zone_performance, aes(x = reorder(markets_zone,-total_revenue_in_M), y = total_revenue_in_M)) +
  geom_bar(stat = "identity", fill = "tomato") +
  geom_text(aes(label = paste0(total_revenue_in_M,"M")), 
            position = position_dodge(width = 0.9), 
            vjust = -0.4, size = 2.5) +      # Adjusting size and position of text
  labs(title = "Total Revenue by Market Zone", x = "Market Zone", y = "Total Revenue ($ Million)") +
  theme_classic()
r_m        # Displaying the plot

# ------  Statistical Test: Kruskal-Wallis Test  ------
# Analyzing Revenue by Market Zone
# The Kruskal-Wallis test evaluates if there are significant differences in revenue across different market zones
kruskal_test_market_sales <- kruskal.test(revenue ~ markets_zone, data = cleaned_sales_data)
kruskal_test_market_sales                  # Displaying the results of the Kruskal-Wallis test

#-----  5b.  Evaluation of Profitability  Across Market Zone.   -----#

# ------  Bar plot of total profit by Market Zone  ------
p_m <- ggplot(zone_performance, aes(x = reorder(markets_zone,-total_profit_in_M), y = total_profit_in_M)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  geom_text(aes(label = paste0(total_profit_in_M,"M")), 
            position = position_dodge(width = 0.9), 
            vjust = -0.4, size = 2.5) +    # Adjusting size and position of text
  labs(title = "Total Profit by Market Zone", x = "Market Zone", y = "Total Profit ($ Million)") +
  theme_classic()
p_m         # Displaying the plot

# ------  Statistical Test: Kruskal-Wallis Test  ------
# Performing the Kruskal-Wallis test on Profit by Market Zone
# This test checks if there are significant differences in Profit across different market zones
kruskal_test_market_profit <- kruskal.test(profit ~ markets_zone, data = cleaned_sales_data)
kruskal_test_market_profit          # Displaying the results of the Kruskal-Wallis test

# ------  Combining and Displaying the plots  ------
combined_plot_1 <- r_m/p_m     # Combining the revenue plot (r_m) and profit plot (p_m)
combined_plot_1                # Displaying the combined plot


# ==========================================================================================================

#######  6. Revenue and Profitability Analysis by Product Type.  #######

# ==========================================================================================================

#-----   I. Project Overview   -----#

#---  Business Challenge:
# The company seeks to understand how revenue and profit vary across different product types,identifying which 
# products are most profitable and which are under- performing. By gaining these insights,leadership can 
# optimize resources, marketing strategies, and inventory management to drive growth and reduce costs.

#---  Project Goal: 
# This project aims to evaluate revenue and profitability performance by product type, providing actionable insights
# to support strategic decision-making and improve overall business efficiency.

#-----   II. Key Business Question   -----#

#---  Business Question: 
# How do revenue and profit vary across different product types?

#---  Approach:
# Write R Script to calculate and compare revenue and profitability metrics for each product type.
# Identify top-performing and under-performing product types based on revenue and profit margins.
# Perform statistical significance tests to assess differences in financial performance by product type.
# Create clear visualizations (bar charts) to illustrate trends and patterns.
# Provide actionable, data-driven recommendations to capitalize on high-performing products and address inefficiencies, supporting strategic business growth initiatives.

# ----------------------------------------------------------------------

#######   6a. Evaluation of Revenue Across Product Types.  #######

# ------  Revenue Performance Across Product Types. ------
product_revenue <- cleaned_sales_data %>%
  group_by(product_type) %>%        # Grouping the data by product type
  summarise(total_revenue_in_M = round((sum(revenue))/ 1e6, 2))    # Summing revenue and converting to millions

# ------  Bar plot of total revenue across Product Type  ------
r_p <- ggplot(product_revenue, aes(x = reorder(product_type, -total_revenue_in_M), y = total_revenue_in_M)) +    # Reordering product types by revenue
  geom_bar(stat = "identity", fill = "tomato") +             # Creating a bar plot with "tomato" color
  geom_text(aes(label = paste0(total_revenue_in_M,"M")),     # Adding revenue labels to each bar
            position = position_dodge(width = 0.9), 
            vjust = -0.4, size = 2.5) +                      # Adjusting the text position and size for clarity
  labs(title = "Total Revenue by Product Type", x = "Product Type", y = "Total Revenue ($ Million)") +  # Customizing plot labels
  theme_classic()   
r_p       # Displaying the plot

# ------  Statistical Test: Kruskal-Wallis Test  ------
# Performing the Kruskal-Wallis test on Revenue by Product Type
kruskal_test_product <- kruskal.test(revenue ~ product_type, data = cleaned_sales_data)     # Checking if revenue vary across product types
kruskal_test_product      # Displaying the result of the test

#-----   6b. Evaluation of Profitability Across Product Types  -----#

# ------  Profit Performance Across Product Types  ------
product_profit <- cleaned_sales_data %>%
  group_by(product_type) %>%
  summarise(total_profit_in_M = round((sum(profit)) / 1e6, 2))      # Summarizing total profit by product type

# ------  Bar Plot of Total Profit across Product Type  ------
p_p <- ggplot(product_profit, aes(x = reorder(product_type, -total_profit_in_M), y = total_profit_in_M)) +
  geom_bar(stat = "identity", fill = "steelblue") +        
  geom_text(aes(label = paste0(total_profit_in_M, "M")), 
            position = position_dodge(width = 0.9), 
            vjust = -0.4, size = 2.5) +                    # Adding labels above bars with adjusted position and text size
  labs(title = "Total Profit by Product Type", x = "Product Type", y = "Total Profit ($ Million)") +  # Chart labels
  theme_classic()       
p_p      # Displaying the plot

# ------  Statistical Test: Kruskal-Wallis Test  ------
# Performing the Kruskal-Wallis Test on Profit by Product Type
kruskal_test_product_profit <- kruskal.test(profit ~ product_type, data = cleaned_sales_data)    # Testing for differences in profit by product type
kruskal_test_product_profit         # Displaying test results

# ------  Combining and Displaying the revenue and Profit Plots  ------
combined_plot_2 <- r_p / p_p      # Combining the revenue plot (s_p) and profit plot (p_p)
combined_plot_2                   # Displaying the combined plot


# ==========================================================================================================

#######  7. Revenue and Profitability Analysis by Customer Types.   #######

# ==========================================================================================================

#-----   I. Project Overview   -----#

#---  Business Challenge:
# The company seeks to uncover how revenue and profit contributions vary across different customer types.
# By understanding these patterns, leadership can make informed decisions to allocate resources,
# optimize marketing strategies, and drive targeted initiatives for customer retention and revenue growth.

#---  Project Goal:
# This project aims to evaluate revenue and profitability performance by customer type, providing 
# actionable insights to support strategic business growth and enhance customer relationship management.

#-----   II. Key Business Question  -----#

#---  Business Question:
# How do revenue and profit vary across different customer types?

#---  Approach:
# Write R Script to calculate and compare revenue and profitability metrics for each customer type.
# Identify top-performing and under-performing customer segments based on revenue and profit margins.
# Perform statistical significance tests to assess differences in financial performance by customer type.
# Create clear visualizations (bar charts) to illustrate trends and patterns.
# Provide actionable, data-driven recommendations to capitalize on high-performing customer segments and address inefficiencies, supporting strategic business growth initiatives.

# ------------------------------------------------------------------------------

#-----  7a. Evaluation of Revenue Across Customer Types.  -----#

# ------   Revenue Performance Across Customer Types  ------
# Grouping Cleaned_Sales_Data by customer type and calculate the total revenue in millions
customer_sales <- cleaned_sales_data %>%
  group_by(customer_type) %>%
  summarise(total_revenue_in_M = round((sum(revenue)) / 1e6, 2))

# ------  Visualizing Total Revenue by Customer Type  ------
# Creating bar plot to show total revenue for each customer type
r_c <- ggplot(customer_sales, aes(x = reorder(customer_type, -total_revenue_in_M), y = total_revenue_in_M)) +
  geom_bar(stat = "identity", fill = "tomato") +             # Bar plot with tomato-colored bars
  geom_text(aes(label = paste0(total_revenue_in_M, "M")),    # Adding labels showing revenue values in millions
            position = position_dodge(width = 0.9), 
            vjust = -0.4, size = 3) +                        # Adjusting label size and vertical position
  labs(
    title = "Total Revenue by Customer Type",       # Adding an informative title
    x = "Customer Type",  # Label for x-axis,        # Labeling for x-axis
    y = "Total Revenue ($ Million)"               # Labeling for y-axis
  ) +
  theme_classic()     
r_c                   # Displaying the plot

# ------  Statistical Test: Kruskal-Wallis Test  ------
# Performing the Kruskal-Wallis test to assess if revenue vary significantly across customer types
kruskal_test_customer <- kruskal.test(revenue ~ customer_type, data = cleaned_sales_data)
kruskal_test_customer      # Displaying test results

#-----  7b. Evaluation of Profitability Across Customer Types  -----#

# ------  Profit Performance Across Customer Types  ------
# Grouping Cleaned Sales Data by customer type and calculate total profit in millions
customer_profit <- cleaned_sales_data %>%
  group_by(customer_type) %>%
  summarise(total_profit_in_M = round((sum(profit)) / 1e6, 2))

# ------  Visualizing Total Profit by Customer Type  ------
# Creating bar plot to show total profit for each customer type
p_c <- ggplot(customer_profit, aes(x = reorder(customer_type, -total_profit_in_M), y = total_profit_in_M)) +
  geom_bar(stat = "identity", fill = "steelblue") +         # Bar plot with steel-blue bars
  geom_text(aes(label = paste0(total_profit_in_M, "M")),    # Adding labels showing profit values in millions
            position = position_dodge(width = 0.9), 
            vjust = -0.4, size = 3) +  # Adjust label size and vertical position
  labs(
    title = "Total Profit by Customer Type",     # Adding an informative title
    x = "Customer Type",                         # Labeling for x-axis
    y = "Total Profit ($ Million)"               # Labeling for y-axis
  ) +
  theme_classic()           
p_c     # Displaying the plot

# ------  Statistical Test: Kruskal-Wallis Test  ------
# Performing the Kruskal-Wallis test to assess if profit varies significantly across customer types
kruskal_test_customer_profit <- kruskal.test(profit ~ customer_type, data = cleaned_sales_data)
kruskal_test_customer_profit        # Displaying test results

# ------  Combined Visualization: Revenue and Profit by Customer Type  ------
# Combining the sales (s_c) and profit (p_c) plots for a side-by-side comparison
combined_plot_3 <- r_c + p_c
combined_plot_3       # Displaying the combined plots


# ==========================================================================================================

#######  8. Exploratory and Statistical Correlation Analysis with Significance Testing.  #######

# ==========================================================================================================

#-----   I.Project Overview   ----#

#---  Business Challenge:
# The company wants to understand the strength and direction of relationships between key business variables.
# By performing statistical correlation analysis, leadership can uncover hidden patterns, assess dependencies,
# and identify factors that significantly impact sales, profitability, and overall performance.
# This analysis will help inform strategic decision-making, prioritize impactful areas, and mitigate risks.

#---  Project Goal: 
# This project aims to conduct an exploratory and statistical correlation analysis with significance testing
# to reveal meaningful relationships between variables. The insights gained will provide a data-driven foundation for
# optimizing sales strategies, enhancing profitability, and guiding business growth initiatives with greater confidence.

#-----   Key Business Question   -----#

#---  Business Question: 
# What are the strengths and directions of relationships between key business variables, and which of these correlations are statistically significant?

#---  Approach: 
# Write R Script to create a correlation matrix using the psych package.
# Perform statistical correlation analysis, including significance testing and confidence intervals, to assess the reliability of the observed relationships.
# Identify strong, moderate, and weak correlations, along with their directions (positive or negative). 
# Create clear visualizations (correlation heatmaps) to illustrate the relationships between variables.
# Provide actionable insights to leverage strong positive correlations, mitigate risks from strong negative correlations, and validate strategic decisions with statistical rigor.

# ---------------------------------------------------------------------------------

# Loading necessary libraries
library(corrplot)
library(psych)
library(ggstatsplot)

# -------  8a. Correlation Matrix with corrplot.  -------
# Prepare the data for correlation analysis
cor_data <- cleaned_sales_data %>%
  select(revenue, profit, cost_price, volume) 

# Visualize the correlation matrix
corrplot(corr = cor(cor_data ),
         addCoef.col = "white",
         number.cex = 0.9,
         number.digits = 1,
         diag = FALSE,
         bg = "lightgray",
         outline = "black",
         addgrid.col = "white",
         mar = c(1,1,1,1),
         main = "Correlation Matrix: Revenue, Profit, Cost Price, and Volume"
           )

# ------  8b. Correlation Matrix with psych.   -------
# Select only the numeric columns
numerical_data <- cleaned_sales_data %>%
  select(revenue, profit, volume, cost_price)

# Compute the correlation matrix
correlation_results <- psych::corr.test(
  numerical_data,        # Dataset containing numeric variables
  method = "pearson",    # Method for correlation (default is Pearson)
  adjust = "none"        # Adjustment method for p-values
)

# View the correlation matrix
print(correlation_results$r)       # Correlation coefficients (r-values)

# View the p-values to test significance of correlations
print(correlation_results$p)       # P-values


# ------------------------------------------------------------------------------------------------------------------------------

#######  9. Identifying Key Drivers of Revenue Performance: Insights from Feature Importance & Regression Analysis.  #######

# -----------------------------------------------------------------------------------------------------------------------------

#-----   I. Project Overview  -----#

#---  Business Challenge: 
# The company seeks to identify the key drivers that significantly impact revenue performance.
# By understanding these factors, leadership can optimize strategies, allocate resources efficiently,
# and make data-driven decisions to boost sales effectiveness and overall business growth.

#---  Project Goal:
# This project aims to uncover the most influential factors contributing to revenue outcomes through
# feature importance analysis and regression modeling. The insights gained will help prioritize strategic
# initiatives, enhance marketing efforts, and improve financial forecasting accuracy.

#-----   II. Key Business Question  -----#

#---  Business Question: 
# What key drivers contribute to revenue performance?
 
#---  Approach:
# Write R Script to perform feature importance analysis using machine learning models (e.g., Random Forest and XGBoost).
# Identify and rank the top drivers of revenue, highlighting their significance and direction of impact.
# Assess model accuracy and significance through metrics such as R-squared, p-values, and confidence intervals.
# Create visualizations to communicate key insights clearly.
# Provide actionable recommendations to leverage positive drivers and mitigate negative influences, supporting data-backed decision-making for revenue optimization.

# --------------------------------------------------------------------------------

# Convert categorical variables into factors
cleaned_sales_data$product_type <- as.factor(cleaned_sales_data$product_type)
cleaned_sales_data$customer_type <- as.factor(cleaned_sales_data$customer_type)
cleaned_sales_data$markets_state <- as.factor(cleaned_sales_data$markets_state)

str(cleaned_sales_data)

# -------  9a. Feature Importance Plot with XGBoost Model.  -------
# Loading necessary libraries
library(xgboost)
library(Matrix)

# Preparing data
revenue_matrix <- model.matrix(revenue ~ customer_type + product_type + 
                               markets_state + volume + cost_price + profit + profit_margin, data = cleaned_sales_data)
revenue_target <- cleaned_sales_data$revenue

# Using XGBoost Model
# Training the XGBoost model
xgb_model <- xgboost(data = as.matrix(revenue_matrix), label = revenue_target, 
                     nrounds = 50, objective = "reg:squarederror")

# Feature Importance Plot with XGBoost Model
importance_matrix <- xgb.importance(model = xgb_model)
xgb.plot.importance(importance_matrix, main = "Feature Importance for Revenue Using the XGBoost Model")

# ------  9b. Variables Significantly Influencing Revenue Using a Regression Model.  ------
# The Key Drivers of Revenue using multiple linear regression model.
revenue_model <- lm(revenue ~ cost_price + profit + profit_margin + volume + customer_type + product_type + 
                      markets_state + markets_zone  , data = cleaned_sales_data)

summary(revenue_model)


# ==========================================================================================================

     #####  10. Forecasting Revenue Trends with Time Series Analysis.    #####

# ==========================================================================================================

#-----   I. Project Overview  -----#

#---  Business Challenge:
# The company seeks to accurately forecast revenue trends over the next 36 months. By anticipating fluctuations
# and identifying long-term growth opportunities, leadership can make proactive, data-driven decisions that
# strengthen financial performance and market competitiveness.

#---  Project Goal:
# This project aims to build a time series forecasting model to predict revenue trends over the next three years.
# The insights will support strategic initiatives, optimize resource allocation, enhance marketing effectiveness,
# and drive sustainable business growth.

#-----   II. Key Business Question   -----#

#---  Business Question:
# What are the predicted revenue trends for the next 36 months, and how can these insights be leveraged
# to drive favorable business decisions?

#---  Approach:
# Collect and preprocess historical revenue data, ensuring accuracy and completeness.
# Develop and fine-tune a time series forecasting model (e.g., ARIMA) to project future revenue.
# Identify seasonal patterns, trends, and potential fluctuations in revenue.
# Develop visualizations to communicate insights effectively
# Provide actionable recommendations on pricing strategies, marketing campaigns, inventory management, and resource allocation based on forecasted revenue patterns.

# --------------------------------------------------------------------------------

# loading necessary library
library(tseries)
    
# Recalling the time series object
Revenue_in_M_ts<- ts(sales_group$Revenue_in_M, start = c(2020,10), end = c(2023,12), frequency = 12) 
Revenue_in_M_ts

#-----  Decomposition of Revenue into Trend and Seasonal Components
plot(stl(Revenue_in_M_ts, "per"), main = "Revenue Decomposition into Seasonal and Trend Components")

# ------  Augmented Dickey Fuller Test for Stationarity  ------
# Checking stationarity 
revenue_adf_test <- adf.test(Revenue_in_M_ts)
print(revenue_adf_test)

# ------  Performing differencing on the series to make it stationary, as the p-value is greater than 0.05  ------
# Checking for stationarity again (1st order differencing)
revenue_adf_test_diff <- adf.test(diff(diff(Revenue_in_M_ts)))
print(revenue_adf_test_diff)

# -------    Revenue Trend Forecast using ARIMA Model.  -------
# loading necessary library
library(forecast)         

# Since the series is stationary, fit ARIMA and specify d = 1 (1st order differencing)
revenue_arima_model <- auto.arima(Revenue_in_M_ts, d = 1)  # 'd=1' means first-order differencing
summary(revenue_arima_model)

# Forecasting Revenue Trends using ARIMA Model
revenue_arima_model <- auto.arima(Revenue_in_M_ts)
forecast_revenue <- forecast(revenue_arima_model, h=36)
plot(forecast_revenue, main = "Revenue Forecast for the Next 3 Years",
     xlab = "Year_Month", ylab = "Revenue Generated ($ million)")

# Print the forecasted values (numeric values)
print(forecast_revenue$mean)


# ==========================================================================================================

#####  11.  Pricing Analysis.  #####

# ==========================================================================================================

#-----   I. Project Overview  -----#

#---  Business Challenge:
# The company seeks to gain a clear understand how selling price, cost price, and profit margin interact to
# impact overall profitability. By identifying these relationships, leadership can uncover pricing inefficiencies,
# optimize revenue strategies, and make informed decisions that drive sustainable business growth.

#---  Project Goal:
# This project aims to analyze the relationships between selling price, cost price, and profit margin using statistical models.
# The insights gained will support strategic pricing decisions, improve profit optimization, and guide long-term financial planning.

#-----   II. Key Business Question   -----#

#---  Business Question:
# What insights can be derived from analysing the relationships between selling price, cost price, and profit margin using statistical models?

#---  Approach:
# Write R Script to build statistical models ( linear regression and correlation analysis) to evaluate how selling and cost prices influence profit margins.
# Collect and preprocess pricing and sales data across different products and segments.
# Apply statistical models (e.g., regression analysis, elasticity modeling) to assess the impact of selling price and cost price on profit margins.
# Segment the analysis to uncover variations in price sensitivity across different product categories or customer segments.
# Provide actionable recommendations on pricing adjustments, discount strategies, and cost optimization to enhance financial outcomes.

# --------------------------------------------------------------------------------

# -------  11a. Calculating Key Pricing Metrics. -------
# Calculating the average selling price and profit margin for each transaction
pricing_data <- cleaned_sales_data %>%
  mutate(selling_price = round(revenue / volume, 2),    # Average selling price per unit
         profit_margin = (profit / revenue) * 100)      # Profit margin as a percentage of revenue
view(pricing_data)      

# Grouping data by product_type and customer_type to calculate the average selling price and average profit margin
pricing_summary <- pricing_data %>%
  group_by(product_type, customer_type) %>%
  summarise(avg_selling_price = round(mean(selling_price), 2),      # Average selling price by group
            avg_profit_margin = round(mean(profit_margin), 2))      # Average profit margin by group
view(pricing_summary)        

# ------ 11b. Analysing Price Elasticity of Demand.  ------
# Price Elasticity = % Change in Quantity Sold / % Change in Price
pricing_data <- pricing_data %>%
  arrange(order_date) %>%
  mutate(price_change = (selling_price - lag(selling_price)) / lag(selling_price),    # % Change in price
         quantity_change = (volume - lag(volume)) / lag(volume),                      # % Change in quantity sold
         price_elasticity = quantity_change / price_change)                           # Price elasticity of demand
view(pricing_data)       

# Filtering out rows where price elasticity is NA or zero
pricing_data <- pricing_data %>%
  filter(!is.na(price_elasticity) & price_elasticity != 0)  # Remove NA and zero values
summary(pricing_data$price_elasticity)       # Summary of price elasticity

# ------  Identifying Elastic Products Based on Price Elasticity.  ------
# Assuming `elasticity_data` is a vector of price elasticity values
elasticity_data <- data.frame(elasticity = c(-Inf, -1.8489, -0.1290, 0.9541, Inf))

# Filter for products with elasticity greater than 1 (elastic products)
elastic_products <- elasticity_data[elasticity_data$elasticity > 1, ]
print(elastic_products)  

# Removing infinite values and viewing valid elasticities
valid_elasticity <- elasticity_data[!is.infinite(elasticity_data$elasticity), ]
print(valid_elasticity)     

# -------   11c. The Effect of Selling Price and Cost Price on Profit Margin.  ------
# Building a linear regression model to analyze the effect of selling price, cost price, and revenue on profit margin
pricing_model <- lm(profit_margin ~ selling_price + cost_price + revenue  , data = pricing_data)
summary(pricing_model) 

#-----  11d. Correlation Analysis/Matrix in R
# Selecting numerical columns for correlation analysis
correlation_data <- pricing_data %>% 
  select(selling_price, profit_margin, volume, revenue, cost_price) 

# Calculating the correlation matrix
correlation_matrix <- cor(correlation_data, use = "complete.obs")

# Displaying the correlation matrix
print(correlation_matrix)

# Visualizing the correlation matrix with corrplot
corrplot(correlation_matrix, method = "color", type = "upper", 
         tl.col = "black", tl.srt = 45, addCoef.col = "black", 
         number.cex = 0.7, diag = FALSE)                # Customize plot appearance                  


# ==========================================================================================================

              #####  12.  Top Customers Who Make Up 80% of Total Revenue.  #####
  
# ==========================================================================================================

#-----   I. Project Overview  -----#

#---  Business Challenge:
# The company wants to identify the key customers who contribute the most to its total revenue. By understanding which
# customers make up the majority of revenue, leadership can prioritize engagement efforts, optimize marketing strategies,
# allocate resources efficiently, and strengthen relationships with these high-value clients to drive sustainable growth.

#---  Project Goal:
# This project aims to pinpoint the top customers who collectively contribute to 80% of total revenue. 
# The insights gained will support strategic decisions to retain, nurture, and expand relationships with high-value customers, 
# maximizing revenue potential and fostering long-term business success.

#-----   II. Key Business Question   -----#

#---  Business Question:
# Which customers contribute to the majority (80%) of the business's total revenue?

#---  Approach:
# Write R Script to calculate cumulative revenue contributions by customer.
# Perform Pareto analysis to identify the top 20% of customers responsible for 80% of total revenue.
# Create a visualization (Pareto chart) to illustrate the distribution of revenue concentration.
# Highlight patterns, trends, and opportunities for deeper engagement with high-value customers.
# Provide actionable recommendations to prioritize customer retention efforts, personalize marketing strategies, and allocate resources effectively to maximize revenue and business growth.

# --------------------------------------------------------------------------------

# ------  Grouping by Customer Name and Calculating Total Revenue and Volume  ------
# This block aggregates total revenue and volume for each customer and calculates additional metrics such as 
# average volume value, revenue contribution percentage, and cumulative percentage.
revenue_clustering <- cleaned_sales_data %>%
  group_by(custmer_name  ) %>% 
  summarise(Total_Revenue_in_M = round(sum(revenue)/1e6, 2),
            Total_Volume_in_K = round(sum(volume)/1e3, 2), .groups = "drop") %>% 
  arrange(desc(Total_Revenue_in_M)) %>% 
  mutate(Average_Volume_Value = round(Total_Revenue_in_M/Total_Volume_in_K, 2)) %>% 
  mutate(Total_Revenue_percent = round(Total_Revenue_in_M *100/sum(Total_Revenue_in_M), 2)) %>% 
  mutate(Cum_percent = round(cumsum(Total_Revenue_percent), 2)) %>% 
  select(custmer_name , Total_Revenue_in_M, Total_Volume_in_K , 
         Average_Volume_Value , Total_Revenue_percent, Cum_percent) %>% 
  arrange(desc(Total_Revenue_in_M))
view(revenue_clustering)

# ------ Creating a Table for Customers Who Make Up 80% of Total Revenue ------
# Filtering the customers contributing up to 80% of total revenue.
top_80_customers <- revenue_clustering %>%
  filter(Cum_percent <= 80)
view(top_80_customers)

# ------  Creating a Table for Customers Who Make Up 80% of Total Revenue. -------
# Identifying Top Customers Contributing 80% of Revenue
# Plotting a Table for Top Customers 
plot <- top_80_customers  %>% 
  select(custmer_name, Total_Revenue_in_M, Total_Volume_in_K,Total_Revenue_percent, Cum_percent ) %>% 
  gt() %>% 
  tab_header(title = "Top Customers Who Make Up 80% of Total Revenue ($ Million)") %>% 
  cols_align(align = "left")

# Enhancing Table with Styling
plot <- plot %>% 
  gt_theme_pff() %>% 
  gt_highlight_rows(rows = Total_Revenue_in_M >=5.00, fill="lightpink" ) %>% 
  gt_highlight_rows(rows = Total_Revenue_in_M >=3.00 & Total_Revenue_in_M <=5.00 , fill="lightblue" ) %>% 
  gt_plt_bar_pct(Total_Revenue_percent, fill = "steelblue",height = 15, width = 100)

plot    # Displaying the styled table


# ==========================================================================================================

              #######  13. Clustering and Customer Segmentation.  #######

# ==========================================================================================================

#-----   I. Project Overview  -----#

#---  Business Challenge:
# The company wants to identify distinct customer segments that contribute the most to overall revenue and sales volume.
# Understanding these segments enables leadership to optimize resource allocation, refine marketing strategies, 
# and enhance customer engagement. By uncovering patterns in purchasing behavior, the business can implement targeted
# strategies to maximize profitability and drive sustainable growth.

#---  Project Goal:
# This project aims to leverage clustering techniques to segment customers based on purchasing behavior, 
# revenue contribution, and sales volume. The insights gained will help tailor marketing efforts, 
# improve customer retention, and guide strategic business decisions to enhance overall profitability.

#-----   II. Key Business Question   -----#

#---  Business Question:
# Which customer segments, based on clustering, contribute the most to overall revenue and sales volume?

#---  Approach:
# Write R Script to perform customer segmentation using clustering algorithms (e.g., K-Means, Hierarchical Clustering, or DBSCAN).
# Analyze the characteristics of each segment to identify high-value and underperforming customer groups.
# Develop visualizations to illustrate segment differences and revenue contributions.
# Provide actionable recommendations on targeted marketing, personalized engagement strategies, and resource optimization to enhance profitability and business growth.

# --------------------------------------------------------------------------------

# loading necessary library
library(cluster)
 
# --------  Clustering Model for Customer Segmentation  -------
# K-Means Clustering 
kmeans_result <- kmeans(revenue_clustering[, c("Total_Revenue_in_M", "Total_Volume_in_K")], centers = 3)

# Assigning Cluster Labels
# Adding a new column to the dataset to indicate which cluster each customer belongs to.
revenue_clustering$cluster <- kmeans_result$cluster

# -------  Visualising K-Means Clustering Results  -------
# Creating a scatter plot to visualize customer segments based on revenue and volume.
# Points are colored according to their assigned cluster.
plot(
  revenue_clustering$Total_Revenue_in_M,    # X-axis: Total Revenue
  revenue_clustering$Total_Volume_in_K,     # Y-axis: Total Volume
  col = revenue_clustering$cluster,         # Color based on cluster assignment
  main = "Customer Segmentation using Clustering Model",  # Plot title
  xlab = "Total Revenue ($ Million)",       # X-axis label
  ylab = "Total Volume (Thousand)",          # Y-axis label
  pch = 19
  )

