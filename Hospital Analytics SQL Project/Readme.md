# 🏥 Hospital Analytics SQL Project

## 📌 Project Overview

This project demonstrates the end-to-end process of building and analyzing a healthcare database using **MySQL**.

Starting with raw CSV files, I designed a relational database schema, imported complex datasets, and wrote advanced SQL queries to uncover operational inefficiencies, revenue drivers, and patient retention trends.

## 📂 Database Schema

The database `hospital_analytics` consists of 5 relational tables:

  * **`patients`**: Demographics & insurance details.
  * **`doctors`**: Specialization, branch location, and tenure.
  * **`appointments`**: Visit logs, status (Completed/Cancelled), and timestamps.
  * **`treatments`**: Clinical procedures and associated costs.
  * **`billing`**: Transaction records, payment methods, and status.

## 🛠️ Key SQL Skills Demonstrated

  * **Database Design**: Wrote `CREATE TABLE` scripts with appropriate data types (`DECIMAL`, `DATE`, `VARCHAR`) and constraints (`PRIMARY KEY`).
  * **ETL (Extract, Transform, Load)**: Used `LOAD DATA LOCAL INFILE` to bulk import 500+ records from raw CSVs into MySQL.
  * **Complex Joins**: Performed multi-level joins (up to 5 tables) to link billing data back to doctor specializations.
  * **Advanced Aggregation**: Used `GROUP BY`, `HAVING`, and `COUNT(DISTINCT)` to analyze KPIs like "Revenue by Branch."
  * **Window Functions**: Applied `RANK()`, `LEAD()`, `LAG()`, and `ROW_NUMBER()` for advanced analytics (e.g., patient retention lag, top-performing doctors).
  * **CTEs (Common Table Expressions)**: Wrote modular queries to calculate multi-step metrics like "High-Value Patient" segmentation.

## 📊 Key Analysis & Insights

### 1\. 💰 Financial Performance

  * **Top Earners:** Ranked doctors by total revenue generated using CTEs.
  * **Revenue Streams:** Compared "Insurance" vs. "Cash" revenue month-over-month to track payment trends.
  * **Profit Margins:** Calculated net profit per treatment type assuming fixed operational costs.

### 2\. 🏥 Operational Efficiency

  * **Branch Performance:** Calculated "Revenue per Doctor" to identify the most efficient hospital branch (Central Hospital).
  * **Idle Capacity:** Identified doctors with zero scheduled appointments using `LEFT JOIN` and `IS NULL` filters.
  * **Missed Revenue:** Quantified the financial impact of "Cancelled" and "No-show" appointments (\~$294k potential loss).

### 3\. 👥 Patient Intelligence

  * **Retention:** Calculated "Days Since Last Visit" using `LAG()` to identify at-risk patients.
  * **Segmentation:** Grouped patients into Age Buckets (Under 30, 30-50, Over 50) for targeted marketing.
  * **Loyalty:** Identified "Recurring Visitors" (\>3 visits) to support a loyalty program initiative.

## 💻 Sample SQL Queries

*(Include a few of your best queries here. I've added two examples for you.)*

**Example 1: Ranking Doctors by Revenue (CTE)**

```sql
WITH DoctorRevenue AS (
    SELECT 
        d.doctor_id, 
        d.first_name, 
        d.last_name, 
        SUM(b.amount) AS total_revenue
    FROM doctors d
    JOIN appointments a ON d.doctor_id = a.doctor_id
    JOIN treatments t ON a.appointment_id = t.appointment_id
    JOIN billing b ON t.treatment_id = b.treatment_id
    GROUP BY d.doctor_id, d.first_name, d.last_name
)
SELECT * FROM DoctorRevenue ORDER BY total_revenue DESC LIMIT 3;
```

**Example 2: Patient Retention Lag (Window Function)**

```sql
SELECT 
    patient_id,
    appointment_date,
    DATEDIFF(appointment_date, LAG(appointment_date) OVER (PARTITION BY patient_id ORDER BY appointment_date)) AS days_since_last_visit
FROM appointments;
```

-----

**Author:** Ritesh Kumar 
**Tools:** MySQL Workbench, SQL
**Status:** Completed ✅
