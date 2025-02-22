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

#######   6b. Evaluation of Profitability Across Product Types  #######

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

