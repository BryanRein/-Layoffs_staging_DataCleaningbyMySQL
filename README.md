##MySQL Data Cleaning: Layoffs Staging Table
This project demonstrates a full data cleaning pipeline using MySQL, based on the layoffs dataset provided by Alex The Analyst.

Dataset
Source: https://github.com/AlexTheAnalyst/MySQL-YouTube-Series/blob/main/layoffs.csv

Description: The dataset contains layoff records including company, industry, location, date, funding, and layoff details.

Project Overview
This project focuses on cleaning and preparing the dataset for analysis. The main cleaning tasks include:

Creating a staging table to protect raw data

Removing duplicate rows using the ROW_NUMBER() window function

Standardizing text fields such as country and industry

Converting text-based dates into proper DATE format

Handling null or blank values across key columns

Dropping irrelevant or helper columns after cleaning

SQL Techniques Used
Window functions (ROW_NUMBER() OVER PARTITION BY)

Conditional updates using LOWER() and LIKE

Date transformation with STR_TO_DATE()

Self-joins for filling missing values

Schema adjustments with ALTER TABLE

Deduplication and cleanup using DELETE and UPDATE

Files Included
Layoffs_staging_DataCleaningbyMySQL.sql

Contains the full SQL script with clear comments, step-by-step cleaning operations, and structured logic.

Final Outcome
The final cleaned layoffs_staging table is:

Free of duplicates

Standardized in naming and date formats

Cleansed of blank or inconsistent data

Ready for further analysis, visualization, or reporting

Credits
Dataset provided by Alex The Analyst
Inspired by Alex’s MySQL YouTube tutorial series
