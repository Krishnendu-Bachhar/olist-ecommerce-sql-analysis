# 🛒 E-Commerce Analytics Project (SQL + Power BI)

## 📌 Overview
This project analyzes the Brazilian E-Commerce dataset (Olist) using **SQL (MySQL)** and **Power BI** to uncover business insights related to revenue, customer behavior, logistics, and product performance.

The project focuses heavily on **SQL-based data modeling, transformation, and analysis**, followed by visualization in Power BI.

---

## 🧠 Objectives
- Analyze revenue trends and growth patterns
- Understand customer behavior and retention
- Evaluate logistics performance and delivery delays
- Identify top-performing products and sellers
- Build a scalable analytics pipeline using SQL

---

## 🛠️ Tech Stack
- **Database:** MySQL  
- **Query Language:** SQL  
- **Visualization:** Power BI  
- **Techniques Used:**
  - Joins & Aggregations  
  - CTEs (Common Table Expressions)  
  - Window Functions (RANK, LAG)  
  - CASE Statements  
  - Data Cleaning & Validation  
  - View Creation  

---

## 📂 Project Structure
 sql/
├── 01_schema_constraints.sql
├── 02_data_quality_checks.sql
├── 03_metric_definitions.sql
├── 04_core_analysis.sql
└── 05_advanced_analysis.sql


---

## 📊 Key Insights

- 📉 **Customer Retention is extremely low (~3%)**
- 🚚 **Late deliveries significantly reduce customer ratings (4.29 → 2.57)**
- 📈 Revenue growth is heavily dependent on **new customer acquisition**
- 🏷️ Sales are concentrated in a few product categories
- 💳 Credit card dominates payments (~74%)

---

## 📈 Dashboard Highlights

### 🔹 Executive Overview
![Dashboard](assets/dashboard_overview.png)

### 🔹 Revenue Trends
![Revenue](assets/revenue_trend.png)

### 🔹 Customer Analysis
![Customers](assets/customer_analysis.png)

### 🔹 Logistics & Delivery
![Logistics](assets/logistics_analysis.png)

---

## 📊 SQL Highlights

- Built reusable **SQL views for KPIs**
- Implemented **customer segmentation using CASE**
- Used **window functions for ranking and growth analysis**
- Applied **CTEs for modular query building**
- Ensured **data integrity with primary and foreign keys**

---

## 🚀 How to Use

1. Import dataset into MySQL
2. Run SQL scripts in order:
   - Schema → Data Quality → Metrics → Analysis → Advanced
3. Connect Power BI to MySQL
4. Load views and build dashboard

---

## 📌 Conclusion

This project demonstrates how SQL can be used not just for querying data, but for building a complete analytics workflow that drives business insights and decision-making.

---

## 🤝 Connect

If you found this project interesting, feel free to connect or reach out!
