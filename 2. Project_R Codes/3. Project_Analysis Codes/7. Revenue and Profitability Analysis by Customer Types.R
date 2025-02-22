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
# Identify top-performing and underperforming customer segments based on revenue and profit margins.
# Perform statistical significance tests to assess differences in financial performance by customer type.
# Create clear visualizations (bar charts) to illustrate trends and patterns.
# Provide actionable, data-driven recommendations to capitalize on high-performing customer segments and address inefficiencies, supporting strategic business growth initiatives.

# ------------------------------------------------------------------------------

#######  7a. Evaluation of Revenue Across Customer Types.  #######

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
    x = "Customer Type",                            # Labeling for x-axis
    y = "Total Revenue ($ Million)"                 # Labeling for y-axis
  ) +
  theme_classic()     
r_c                   # Displaying the plot

# ------  Statistical Test: Kruskal-Wallis Test  ------
# Performing the Kruskal-Wallis test to assess if revenue vary significantly across customer types
kruskal_test_customer <- kruskal.test(revenue ~ customer_type, data = cleaned_sales_data)
kruskal_test_customer      # Displaying test results

#######  7b. Evaluation of Profitability Across Customer Types  #######

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
    x = "Customer Type",  # Label for x-axis     # Labeling for x-axis
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

