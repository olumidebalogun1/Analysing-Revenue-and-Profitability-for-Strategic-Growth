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