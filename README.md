# ClickThroughRate
<h3> Developed by Wenyi Hu </h3>

## Background
Real-time bidding (RTB) that features perimpression-level real-time ad auctions is the process in which digital advertising inventory is bought and sold. This process occurs in less than a second. In RTB, click-through rate (CTR) prediction is a fundamental problem to ensure the success of an ad campaign and boost revenue. 
![image](https://user-images.githubusercontent.com/112957640/194691719-0f7e6b87-b910-4f7b-96ca-8f7b781abbdc.png)

This repo aims at predicting the CTR by using MySQL server (and DataGrip) to create database, importing raw data from csv files to created tables, and loading the data to Jupyter by using SQLAlchemy to develop a classical classification model with highly imbalanced and large dataset. 

![image](https://user-images.githubusercontent.com/112957640/194691671-01a4ebd1-fc1d-42f8-8899-3866c33d78b8.png)

The baseline model is built for checking the feature importance, and considering oversampling or undersampling. A model with k-fold cross validation is also trained to predict the CTR. Lastly, the parameters of classification algorithms like DecisionTree, RandomForest, KNN, and LogisticRegression are tuned by building a pipeline in GridSearchCV for generating the best estimator to get more accurate scores (For CTR ML, the higher recall score is more important because the advertiser won't want miss any possible ad clicks).

## Part 1 - SQL 
1. Using MySQL (and DataGrip) to create a database
2. Create table schemas, set appropriate data types, and import the raw data
3. Run database queries to prepare modelling datasets
    
## Part 2 - Machine Learning
1. Use Python to connect to MySQL and read tables into Pandas Dataframes
2. Clean/preprocess/EDA/feature engineer data for machine learning
3. Train a ML model to predict if a user will click on an ad
4. Evaluate model performance
