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

