
# 🏥 Hospital Operations & Revenue Analysis (Excel Project)

## 📌 Project Overview
This project involves the comprehensive analysis of a synthetic healthcare dataset containing **500+ records** across five related tables (Patients, Doctors, Appointments, Treatments, Billing).

The goal was to simulate a real-world **Healthcare Analyst** role by diagnosing operational bottlenecks, calculating revenue concentration (Pareto Principle), and identifying patient retention trends using **Advanced Excel** techniques.

## 📂 Dataset Structure
The analysis connects five relational CSV files:
* **`appointments.csv`**: Scheduling details, status (Completed/Cancelled), and timestamps.
* **`billing.csv`**: Transaction amounts, payment methods (Cash/Insurance), and status.
* **`doctors.csv`**: Medical staff details, specialization, and tenure.
* **`patients.csv`**: Demographics, registration dates, and insurance providers.
* **`treatments.csv`**: Clinical procedure details and costs.

## 🛠️ Tools & Skills Demonstrated
* **Data Modeling**: Linked disparate datasets using **VLOOKUP** and **XLOOKUP** to create a unified view of the business.
* **Advanced Pivot Tables**: Used Calculated Fields, Grouping (Date/Time), and Slicers to summarize complex data.
* **Logical Functions**: Applied nested `IF`, `AND`, `OR`, and `MAXIFS` for audit flagging and outlier detection.
* **Date Intelligence**: Analyzed lag times and retention cohorts using date functions (`YEAR`, `HOUR`, `DATEDIF`).
* **Business Statistics**: Calculated the **Pareto Principle (80/20 Rule)** for revenue concentration.

## 📊 Key Insights Uncovered

### 1. Revenue Concentration (Pareto Principle)
* **Finding:** The top **10%** of patients ("VIPs") contribute approximately **21.35%** of the total hospital revenue.
* **Strategy:** Recommended a loyalty program for high-value patients to secure this critical revenue stream.

### 2. Patient Retention Analysis
* **Finding:** **68%** of total revenue ($377k) comes from existing patients (registered before 2023), while new acquisitions contributed only **32%**.
* **Strategy:** Marketing efforts should pivot to focus on *retention* and *recall* campaigns rather than solely new acquisition.

### 3. Operational "Rush Hour"
* **Finding:** The peak load for the front desk occurs at **15:00 (3 PM)**, with a verified spike of **28 appointments** (highest of any hour).
* **Strategy:** Recommended shifting staff schedules to overlap during the 2 PM – 4 PM window to reduce wait times.

### 4. Billing Efficiency
* **Finding:** Identified **32 completed appointments** that remain unpaid (Status: "Pending" or "Failed"), representing potential revenue leakage.
* **Action:** Generated an audit list for the finance team to pursue collections.


## 🚀 How to Use This Repo
1.  **Download** the raw `.csv` files in the `data/` folder.
2.  **Open** the `Hospital_Analysis_Master.xlsx` file to view the final dashboard and formulas.
3.  Check the `Audits` sheet to see the logic used for flagging unpaid bills.

---

**Author:** [Ritesh Kumar ]
**Tools:** Microsoft Excel 365, Data Analysis
**Status:** Completed ✅
