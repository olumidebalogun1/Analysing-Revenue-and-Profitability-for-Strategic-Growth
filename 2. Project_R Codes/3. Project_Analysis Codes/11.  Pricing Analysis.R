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
         number.cex = 0.7, diag = FALSE)                    # Customize plot appearance

