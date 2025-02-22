# =========================================================================================================================================

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

