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
# Write R Script to perform feature importance analysis using machine learning models.
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

