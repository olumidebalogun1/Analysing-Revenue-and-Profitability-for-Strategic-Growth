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

