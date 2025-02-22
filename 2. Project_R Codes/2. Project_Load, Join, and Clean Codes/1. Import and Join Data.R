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
