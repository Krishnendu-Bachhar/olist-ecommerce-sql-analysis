# 🛒 Brazilian E-Commerce Analytics (SQL + Power BI)

## 🚀 Project Overview
This project presents an end-to-end analysis of the Brazilian E-Commerce (Olist) dataset using **MySQL (SQL)** and **Power BI**.

It demonstrates how raw transactional data can be transformed into **actionable business insights** through structured data modeling, advanced SQL analysis, and interactive visualization.

---

## 🎯 Business Objectives
- Analyze revenue growth and performance trends  
- Understand customer behavior and retention patterns  
- Evaluate logistics efficiency and delivery performance  
- Identify top-performing product categories and sellers  
- Build a scalable, SQL-driven analytics pipeline  

---

## 🛠️ Tech Stack

- **Database:** MySQL  
- **Language:** SQL  
- **Visualization:** Power BI  

### 🔹 SQL Capabilities Demonstrated
- Complex **Joins & Aggregations**
- **CTEs (Common Table Expressions)**
- **Window Functions** (RANK, LAG)
- **CASE-based segmentation logic**
- Data cleaning & validation
- Creation of reusable **SQL Views (KPI Layer)**

---

## 📂 Project Structure
📁 sql/
├── 01_schema_constraints.sql
├── 02_data_quality_checks.sql
├── 03_metric_definitions.sql
├── 04_core_analysis.sql
└── 05_advanced_analysis.sql

📁 assets/
📁 reports/
README.md


---

## 📊 Dashboard Structure

### 🔹 1. Overview and Revenue Trend
- Executive KPIs: Revenue, Customers, Sellers  
- Monthly revenue trend & growth patterns  
- Revenue contribution by top categories  

---

### 🔹 2. Customer Behaviour Analysis
- Customer segmentation (Low, Mid, Premium)  
- Spending distribution and value clusters  
- Identification of high-value customers  

---

### 🔹 3. Rating Analysis
- Average ratings across categories  
- Price vs rating relationship  
- Top and worst-rated product categories  

---

### 🔹 4. Logistics Analysis
- Delivery delay percentage  
- Impact of delays on customer ratings  
- Operational performance insights  

---

### 🔹 5. Retention and Demography Analysis
- Customer distribution across states  
- Monthly new customer acquisition trends  
- Analysis of repeat vs one-time customers  

---

### 🔹 6. Business Analysis Report (Executive Summary)
- Consolidated KPIs and performance overview  
- Month-over-month revenue comparison  
- Revenue concentration analysis  
- Key business insights and risks  

---

## 📊 Key Business Insights

- 📉 **~97% customers are one-time buyers → extremely low retention**
- 🚚 **Delayed deliveries reduce ratings by ~40% (4.29 → 2.57)**
- 📈 Revenue growth is heavily dependent on **new customer acquisition**
- 🏷️ A small number of categories contribute the majority of revenue
- 💳 Credit cards dominate payment methods (~74%)

---

## 📸 Dashboard Preview

### 🔹 1. Overview and Revenue Trend
![Overview](assets/overview_revenue.png)

---

### 🔹 2. Customer Behaviour Analysis
![Customer Behaviour](assets/customer_behavior.png)

---

### 🔹 3. Rating Analysis
![Rating Analysis](assets/rating_analysis.png)

---

### 🔹 4. Logistics Analysis
![Logistics](assets/logistics_analysis.png)

---

### 🔹 5. Retention and Demography Analysis
![Retention](assets/retention_demography.png)

---

### 🔹 6. Business Analysis Report
![Business Report](assets/business_report.png)

## 📈 SQL Highlights

- Designed a **relational schema with primary & foreign keys**
- Created reusable **SQL views for business metrics (KPI layer)**
- Applied **window functions** for ranking and time-series analysis
- Built **customer segmentation logic using CASE statements**
- Used **CTEs for modular and readable queries**
- Ensured **data integrity and consistency across datasets**

---

## ⚙️ How to Run the Project

1. Import dataset into MySQL  
2. Execute SQL scripts in sequence:
   - Schema → Data Cleaning → Metrics → Analysis → Advanced  
3. Connect Power BI to MySQL  
4. Load SQL views and build dashboard  

---

## 🧠 Key Takeaway

This project highlights how SQL can be used beyond querying — as a powerful tool for **data modeling, business analysis, and decision-making support**.

---

## 🔗 Connect / Feedback

If you found this project useful or have suggestions, feel free to connect or share feedback!
