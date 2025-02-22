# ==========================================================================================================

#######  13. Clustering and Customer Segmentation.  #######

# ==========================================================================================================

#-----   I. Project Overview  -----#

#---  Business Challenge:
# The company wants to identify distinct customer segments that contribute the most to overall revenue and sales volume.
# Understanding these segments enables leadership to optimize resource allocation, refine marketing strategies, 
# and enhance customer engagement. By uncovering patterns in purchasing behavior, the business can implement targeted
# strategies to maximize profitability and drive sustainable growth.

#---  Project Goal:
# This project aims to leverage clustering techniques to segment customers based on purchasing behavior, 
# revenue contribution, and sales volume. The insights gained will help tailor marketing efforts, 
# improve customer retention, and guide strategic business decisions to enhance overall profitability.

#-----   II. Key Business Question   -----#

#---  Business Question:
# Which customer segments, based on clustering, contribute the most to overall revenue and sales volume?

#---  Approach:
# Write R Script to perform customer segmentation using clustering algorithms (e.g., K-Means, Hierarchical Clustering, or DBSCAN).
# Analyze the characteristics of each segment to identify high-value and underperforming customer groups.
# Develop visualizations to illustrate segment differences and revenue contributions.
# Provide actionable recommendations on targeted marketing, personalized engagement strategies, and resource optimization to enhance profitability and business growth.

# --------------------------------------------------------------------------------

# loading necessary library
library(cluster)

# --------  Clustering Model for Customer Segmentation  -------
# K-Means Clustering 
kmeans_result <- kmeans(revenue_clustering[, c("Total_Revenue_in_M", "Total_Volume_in_K")], centers = 3)

# Assigning Cluster Labels
# Adding a new column to the dataset to indicate which cluster each customer belongs to.
revenue_clustering$cluster <- kmeans_result$cluster

# -------  Visualising K-Means Clustering Results  -------
# Creating a scatter plot to visualize customer segments based on revenue and volume.
# Points are colored according to their assigned cluster.
plot(
  revenue_clustering$Total_Revenue_in_M,    # X-axis: Total Revenue
  revenue_clustering$Total_Volume_in_K,     # Y-axis: Total Volume
  col = revenue_clustering$cluster,         # Color based on cluster assignment
  main = "Customer Segmentation using Clustering Model",  # Plot title
  xlab = "Total Revenue ($ Million)",       # X-axis label
  ylab = "Total Volume (Thousand)",          # Y-axis label
  pch = 19
)

