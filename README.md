# Depression-Risk-Prediction-App-XGBoost
Source code for the adult depression risk prediction web application based on the XGBoost model.
# Adult Depression Risk Prediction Tool (COVID-19 Era)

This repository contains the source code for the web-based predictive application described in our paper: 
*"A Dual-Model Approach to Predicting Adult Depression Risk: Mendelian Randomization and Explainable Machine Learning in the COVID-19 Era"* (Under Review / Published).

## Overview
This Shiny application utilizes an optimized **XGBoost** machine learning model to predict the risk of depression in adults. The predictive features were rigorously selected based on the strict intersection of **multivariate Logistic regression** and **two-sample Mendelian Randomization (MR)** analysis, ensuring both statistical significance and causal robustness.

The final model relies on 4 core predictors:
1. Weekday Sleep Quality
2. Body Mass Index (BMI)
3. Household Smoking Exposure
4. History of Arthritis

## Web Application
You can access the live interactive application here:
[https://lyx2005.shinyapps.io/Adult_Depression_Risk_Prediction_Tool/](https://lyx2005.shinyapps.io/Adult_Depression_Risk_Prediction_Tool/)

## Repository Contents
* `app.R`: The complete R source code for the Shiny user interface and server logic.
* `xgb_model.json`: The pre-trained XGBoost model utilized for making real-time predictions and generating SHAP (SHapley Additive exPlanations) values.

## Dependencies
To run this application locally, ensure you have R installed along with the following packages: `shiny`, `xgboost`, `shapviz`, `ggplot2`.
