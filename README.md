# SQL Data Cleaning & EDA Preparation Project

## 📌 Project Overview
This project focuses on cleaning a messy business dataset using **SQL (MySQL)** and preparing it for **Exploratory Data Analysis (EDA)**.

The dataset contained real-world issues such as duplicate records, inconsistent categorical values, blank entries, text values in numeric columns, and missing data.  
The goal of this project was not just to clean the data, but to make **correct analytical decisions** while handling it.

---

## 🧠 What I Did in This Project

- Created a **backup table** from the raw dataset to ensure data safety  
- Identified and removed **duplicate records** using `ROW_NUMBER()` and window functions  
- Standardized categorical columns:
  - Gender → Male / Female  
  - Churn → Yes / No  
- Detected and handled **blank values (`''`), `N/A`, and `Unknown` entries**  
- Converted blank and invalid values into **NULL** for analytical correctness  
- Cleaned numeric columns stored as text:
  - Age  
  - Annual_Income  
  - Spending_Score  
- Converted cleaned numeric columns into proper **INT data types**  
- Carefully decided **when to fill missing values and when to keep NULLs**:
  - Filled Age and Annual Income for learning and EDA purposes  
  - Kept Spending Score and Churn as NULL where data was genuinely missing  
- Performed **final NULL audits and sanity checks** to ensure the dataset is EDA-ready  

---

## 🛠️ Tools & Technologies Used
- MySQL  
- SQL (CTEs, JOINs, Window Functions, Aggregations)  
- MySQL Workbench  

---

## 📂 Project Structure

sql-data-cleaning-project/
│
├── dataset/
│ └── messy_business_dataset.csv
│
├── sql/
│ └── data_cleaning.sql
│
├── README.md


---

## 📈 Outcome
The final dataset is:
- Free from duplicates  
- Properly standardized  
- Cleaned of dirty text values  
- Converted to correct data types  
- Ready for **EDA, visualization, and further analysis** in tools like Power BI, Tableau, or Python  

This project reflects how **real-world data cleaning is performed in practice**, where not all missing values are filled blindly.

---

## 🎯 Key Learning
> Data cleaning is not about forcing perfect data —  
> it’s about making the **right analytical decisions**.

---

## 🙌 Feedback
If you notice any issues, better approaches, or improvements in this project,  
I would genuinely appreciate your feedback. It will help me improve as a data analyst.

---

## 🔖 Tags
SQL · Data Cleaning · MySQL · EDA · Analytics · Portfolio Project

