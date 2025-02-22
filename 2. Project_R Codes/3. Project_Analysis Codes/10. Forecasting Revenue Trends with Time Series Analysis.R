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
revenue_arima_model <- auto.arima(Revenue_in_M_ts, d = 1)         # 'd=1' means first-order differencing
summary(revenue_arima_model)

# Forecasting Revenue Trends using ARIMA Model
revenue_arima_model <- auto.arima(Revenue_in_M_ts)
forecast_revenue <- forecast(revenue_arima_model, h=36)
plot(forecast_revenue, main = "Revenue Forecast for the Next 3 Years",
     xlab = "Year_Month", ylab = "Revenue Generated ($ million)")

# Print the forecasted values (numeric values)
print(forecast_revenue$mean)

