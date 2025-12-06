-- Question 1: The Pediatricians
-- Goal: Find the first_name, last_name, and phone_number of all doctors who specialize in 'Pediatrics'.
	select First_name, last_name , Phone_number
	from doctors
	where specialization = "Pediatrics" ;

-- Question 2: Big Spenders
-- Goal: List all bills (bill_id, amount) where the amount is greater than $4,500 AND the status is 'Paid'.
	select bill_id , amount 
	from billing 
	where amount > 4500 and payment_status = "paid";

-- Level 2: Aggregation (Counting & Summing)
-- Question 3: Insurance Revenue
-- Goal: Calculate the Total Amount of money generated from 'Insurance' payments.
	select bill_id ,Payment_method, sum(amount) total_amount 
	from billing
	where payment_method = "Insurance" 
	group by bill_id;

--  4 .Total Revenue: Calculate the total sum of amount from the billing table.
	select sum(amount) total_amount
	from billing  ;
-- 5.Patient Demographics: Count the total number of patients grouped by gender.
	select gender, count(patient_id) total_patient 
	from patients
	group by gender ;

-- 6. Revenue by Status: Calculate the total money currently stuck in "Pending" vs. "Failed" vs. "Paid" status in the billing table.
	select payment_status , sum(amount) total_amount 
	from billing
	group by payment_status ;

-- 7. Doctor Experience: Find the average years_experience for doctors, grouped by specialization.
	select specialization , 
		round(avg(years_experience),1) total_experience
	from doctors
	group by specialization ;

-- 8. Busiest Branch: Count the number of doctors working in each hospital_branch.
	select hospital_branch , 
		count(doctor_id) total_doctor
	from doctors
	group by hospital_branch ;
-- 9. Treatment Costs: Find the Minimum, Maximum, and Average cost of all records in the treatments table.
	select max(cost) max_cost , min(cost) min_cost,round( avg(cost),1) avg_cost
	from treatments;
 
-- 10. High-Volume Doctors: List the doctor_id and the count of their appointments, but only show doctors who have more than 5 appointments (Hint: Use HAVING).
	select doctor_id , count(appointment_id) total_appointment
	from appointments
	group by doctor_id
	having count(appointment_id ) >5 ;
-- 11 Monthly Workloa d: Count the number of appointments per month (Hint: Use MONTH(appointment_date)).
	SELECT 
		MONTH(appointment_date) AS month_num, 
		COUNT(appointment_id) AS total_appointments
	FROM appointments
	GROUP BY MONTH(appointment_date)
	ORDER BY month_num;

-- 12 Insurance Usage: Count how many unique patients use each insurance_provider.
	select insurance_provider  , 
		count(distinct patient_id) unique_patient
	from patients
	group by insurance_provider;

-- 13 Procedure Popularity: Find the most common reason_for_visit by counting how many times each reason appears in the appointments table.

	select treatment_type , count(*) total_visit 
	from treatments
	group by treatment_type ;
-- Question 14 Patient Count by Gender

select count(*) total_aptient  , gender 
from patients 
where gender = "M";

-- Level 3: The "JOIN" (Linking Tables)
-- *Focus: Connecting tables to tell a story.*
-- Question 15 Doctor's Appointment Count
-- Goal: Show a list of Doctor Last Names and the total number of appointments they have scheduled.
select d.first_name , count(a.appointment_id) total_appointment 
from doctors d join appointments a on d.doctor_id = a.doctor_id
group by d.first_name ;

-- 16.    Patient Appointments:  List all `appointment_id`s along with the `first_name` and `last_name` of the patient 
select a.appointment_id , p.first_name, p.last_name 
	from appointments a 
		join patients p on a.patient_id = p.patient_id ;

-- 17.    Doctor Schedule:  List every appointment along with the Doctor's `last_name` and their `specialization` 
	select a.appointment_id,d.last_name , d.specialization 
	from appointments a inner join doctors d on a.doctor_id = d.doctor_id ; 

-- 18.    Full Treatment Details:  Show the Treatment Description, the Cost, and the associated Doctor's Name for every treatment 
  select d.first_name ,d.last_name, t.description , t.cost
	from treatments t 
		join appointments a on t.appointment_id = a.appointment_id 
		join doctors d on d.doctor_id = a.doctor_id ;
  
-- 19.    Unbooked Patients (Left Join):  List    ALL  patients from the `patients` table and their appointment dates. If they have never had an appointment, show `NULL` 
	select p.patient_id, p.first_name , p.last_name ,a.appointment_date
		from patients p 
			left join appointments a on p.patient_id = a.patient_id 
			where a.appointment_date is null ;
            
-- 20.    Idle Doctors (Left Join + Filter):  Find doctors who have    zero  appointments scheduled. and then filter NULL`).
		select d.doctor_id, d.first_name , d.last_name 
			from doctors d 
				left join appointments a on d.doctor_id = a.doctor_id
			where appointment_id is null ;
            
-- 21.    Billing & Patient Info:  Select the Bill ID, Amount, and the full name of the patient who paid it .
		select b.bill_id ,
			concat(p.first_name ," " , p.last_name ) full_name , b.amount 
        from patients p 
			join billing b on p.patient_id = b.patient_id ;
            
-- 22.    Revenue by Branch:  Calculate the total revenue generated by each `hospital_branch` (Join `billing` $\to$ `treatments` $\to$ `appointments` $\to$ `doctors`).
	select d.hospital_branch , sum(b.amount) total_revenue 
		from billing b 
			join treatments t on b.treatment_id = t.treatment_id 
			join appointments a on t.appointment_id = a.appointment_id 
			join doctors d on a.doctor_id = d.doctor_id
		group by d.hospital_branch 
		order by total_revenue desc ;
-- 23.    Missed Revenue:  Find the total cost of treatments where the appointment status was "Cancelled" or "No-show" (Join `treatments` and `appointments`).
		select t.cost , a.appointment_id , a.status
			from treatments t join appointments a on t.appointment_id = a.appointment_id
            where status = "Cancelled " ;
-- 24.    Patient & Doctor Location:  List appointments where the patient lives on "Pine Rd" AND the doctor works at "Westside Clinic".
		select  a.appointment_id ,
				a.appointment_date,
				p.first_name patient_name ,
				p.address  patirnt_address,
				d.first_name Doctor_name   ,
                d.hospital_branch 
		from patients p join appointments a  on p.patient_id = a.patient_id 
		join  doctors d on d.doctor_id = a.doctor_id 
		where p.address like  "%Pine Rd%"  AND d.hospital_branch = 'Westside Clinic';


-- 25.    Comprehensive Log:  Create a master list showing: `Date`, `Patient Name`, `Doctor Name`, `Treatment Type`, and `Bill Amount` (Join all 5 tables).
			select  a.appointment_date as Date ,
					concat(p.first_name ," " , p.last_name ) Patient_Name ,
                    concat(d.first_name , " " , d.last_name ) Doctor_name ,
                    t.treatment_type ,
                    b.amount as Bill_Amount 
			from billing b 
				join treatments t on b.treatment_id = t.treatment_id 
                join appointments a on a.appointment_id = t.appointment_id 
                join patients p on a.patient_id = p.patient_id
                join doctors d on d.doctor_id = a.doctor_id
			order by a.appointment_date DESC ;
            
            
-- ---

-- ###    Part 3: Common Table Expressions (CTEs)   
-- *Focus: Organizing complex logic into readable steps.*

-- 26.    High-Value Patients:  Create a CTE named `PatientSpend` that calculates total spending per patient. Then, select only the patients who spent more than $5,000.
			WITH PatientSpend AS (
			-- Step 1: Define the CTE (Calculate total spend per patient)
			SELECT 
				patient_id, 
				SUM(amount) AS total_spent
			FROM billing
			GROUP BY patient_id
		) 
        -- Step 2: Select from the CTE (Filter for the VIPs)
			SELECT 
				ps.patient_id,
				p.first_name,
				p.last_name,
				ps.total_spent
			FROM PatientSpend ps
			JOIN patients p ON ps.patient_id = p.patient_id
			WHERE ps.total_spent > 5000
			ORDER BY ps.total_spent DESC;

-- 28.    Top Earners:  Create a CTE to rank doctors by the total revenue they generated. Select the top 3.
		With DoctorRevenue AS (
			 Select d.doctor_id , 
					d.First_name ,
					d.last_name , 
                    sum(b.amount) Total_revenue 
			from doctors d
				join appointments a on d.doctor_id = a.doctor_id
                join treatments t on a.appointment_id = t.appointment_id 
                join billing b on t.treatment_id = b.treatment_id 
			group by d.doctor_id , d.first_name , d.last_name 
            )

		select first_name , last_name , total_revenue 
				from DoctorRevenue
                order by total_revenue desc
                limit 3 ;
                
                
-- 29.    Active Days:  Create a CTE that counts appointments for each date. Then, find which dates had more than 3 appointments.
			With DailyCount As (
				Select appointment_date ,
						count(appointment_id ) as total_Appointment 
				from appointments 
                group by appointment_date  
			)
            
            select appointment_date , Total_appointment
				 from DailyCount 
                 where Total_appointment > 3 
                 order by Total_appointment Desc ; 
                        
-- 30.    Complex Filtering:  Create a CTE of all "Completed" appointments. From that CTE, count how many were for "Dermatology".
			With CompletedAppointment As (
				select doctor_id ,
						appointment_id
				from appointments 
				where status = "completed" 
			)
            
            select 
					count(*) As dermatology 
			from CompletedAppointment ca 
					join doctors d on ca.doctor_id = d.doctor_id 
                    where d.specialization = "dermatology" ;
                    
-- 31.    Multi-Step Revenue:  Create a CTE for "Insurance Revenue" and another for "Cash Revenue". Join them to show the difference per month.
		with InsuranceRevenue As ( 
				select 
					month(Bill_date) as Month_num ,
                    sum(Amount) as Insurance_amount 
				from billing  
                where payment_method = "Insurance"
                group by month(bill_date) 
			),
		CashRevenue As (
				select
					month(Bill_date) as Month_num ,
                    sum(Amount) As Cash_amount 
				from billing
                where payment_method = "Cash"
                group by month(Bill_date )
			)
            select i.Month_num ,
				   i.Insurance_amount , 
                   c.cash_amount , 
                   (i.Insurance_amount - c.cash_amount ) as Revenue_Difference
			from InsuranceRevenue i
					join  CashRevenue c  on i.Month_num = c.Month_num 
                    order by i.Month_num ;
				
-- 32.    Patient Age Bracket:  Create a CTE that calculates every patient's age. Then, group them into buckets (e.g., "Under 30", "30-50", "Over 50") and count them.
			With PatientAge as (
				select 
					patient_id ,
                    timestampdiff(year , date_of_birth , curdate()) age 
                    from patients
                    )
				select 
					case 
						when age < 30 then "Under 30" 
						when age between 30 and 50 then '30-50'
                        else 'Over 50'
						end as age_group,
					count(*) as Patient_count 
                    from PatientAge 
                    group by age_group 
                    order by Patient_count desc ;
-- Recurring Visitors: Create a CTE counting visits per patient. Select details for patients with visits > 3.
		WITH PatientVisits AS (
			SELECT 
				patient_id, 
				COUNT(appointment_id) AS visit_count
			FROM appointments
			GROUP BY patient_id
)
			SELECT 
				p.first_name, 
				p.last_name, 
				pv.visit_count
			FROM PatientVisits pv
			JOIN patients p ON pv.patient_id = p.patient_id
			WHERE pv.visit_count > 3
			ORDER BY pv.visit_count DESC;
            
                    
-- 34.    Treatment Margins:  Assume a fixed cost of $50 for every treatment. Create a CTE calculating "Profit" (Bill Amount - 50) for each transaction, then sum the total profit.
			WITH TreatmentProfit AS (
				SELECT 
					bill_id,
					amount,
					(amount - 50) AS profit
				FROM billing
)
				SELECT 
					SUM(profit) AS total_profit
				FROM TreatmentProfit;
-- 35.    Branch Efficiency:  Create a CTE calculating "Revenue per Doctor" for each branch. Order the branches from most efficient to least.
			WITH BranchRevenue AS (
				-- Step 1: Calculate Total Revenue for each Branch
				SELECT 
					d.hospital_branch,
					SUM(b.amount) AS total_revenue
				FROM doctors d
				JOIN appointments a ON d.doctor_id = a.doctor_id
				JOIN treatments t ON a.appointment_id = t.appointment_id
				JOIN billing b ON t.treatment_id = b.treatment_id
				GROUP BY d.hospital_branch
			),

				BranchHeadcount AS (
					-- Step 2: Count the Number of Doctors at each Branch
					SELECT 
						hospital_branch,
						COUNT(doctor_id) AS doctor_count
					FROM doctors
					GROUP BY hospital_branch
				)
				-- Step 3: Join them and Calculate the Ratio
				SELECT 
					br.hospital_branch,
					br.total_revenue,
					bh.doctor_count,
					ROUND(br.total_revenue / bh.doctor_count, 2) AS revenue_per_doctor
				FROM BranchRevenue br
				JOIN BranchHeadcount bh ON br.hospital_branch = bh.hospital_branch
				ORDER BY revenue_per_doctor DESC;
-- ---

-- ###    Part 4: Window Functions (OVER, RANK, LEAD, LAG)   
-- *Focus: Advanced analytics and ranking without collapsing rows.
-- 31. **Rank by Experience:** List all doctors and `RANK()` them by their `years_experience` (Highest experience = Rank 1).
			SELECT 
				first_name, 
				last_name, 
				years_experience,
				RANK() OVER (ORDER BY years_experience DESC) AS experience_rank
			FROM doctors;
-- 32. **Top Bills:** Use `DENSE_RANK()` to rank bills by amount, partition by `payment_method`. (Find the highest Cash bill, highest Insurance bill, etc.).
			SELECT 
				bill_id, 
				payment_method, 
				amount,
				DENSE_RANK() OVER (PARTITION BY payment_method ORDER BY amount DESC) AS bill_rank
			FROM billing;
-- 33. **Running Total (Revenue):** Calculate a cumulative running total of revenue ordered by `bill_date`.
			SELECT 
				bill_date, 
				amount,
				SUM(amount) OVER (ORDER BY bill_date) AS running_total
			FROM billing;
-- 34. **Appointment Numbering:** Use `ROW_NUMBER()` to assign a sequential number to every appointment for each patient (e.g., Patient A's 1st visit, 2nd visit, etc.).
			SELECT 
				patient_id, 
				appointment_date,
				ROW_NUMBER() OVER (PARTITION BY patient_id ORDER BY appointment_date) AS visit_number
			FROM appointments;
-- 35. **Next Visit (LEAD):** For each patient's appointment, create a column showing the **date of their next appointment** (Hint: `LEAD(appointment_date) OVER (PARTITION BY patient_id ORDER BY date)`).
			SELECT 
				patient_id,
				appointment_date,
				LEAD(appointment_date) OVER (PARTITION BY patient_id ORDER BY appointment_date) AS next_visit_date
			FROM appointments;
-- 36. **Days Since Last Visit (LAG):** Calculate the number of days passed since a patient's **previous** appointment.
			SELECT 
				patient_id,
				appointment_date,
				DATEDIFF(appointment_date, LAG(appointment_date) OVER (PARTITION BY patient_id ORDER BY appointment_date)) AS days_since_last_visit
			FROM appointments;
-- 37. **Price Comparison:** Show each treatment's cost alongside the **Average Cost** of all treatments of that same type (Hint: `AVG(cost) OVER (PARTITION BY treatment_type)`).
			SELECT 
				treatment_type, 
				cost,
				AVG(cost) OVER (PARTITION BY treatment_type) AS avg_type_cost
			FROM treatments;
-- 38. **Top 3 Treatments:** Rank treatments by cost within each `treatment_type` and filter to show only the top 3 most expensive ones.
				WITH RankedTreatments AS (
					SELECT 
						treatment_type, 
						description, 
						cost,
						RANK() OVER (PARTITION BY treatment_type ORDER BY cost DESC) AS cost_rank
					FROM treatments
				)
				SELECT * FROM RankedTreatments WHERE cost_rank <= 3;
-- 39. **Revenue Moving Average:** Calculate a 3-day moving average of daily revenue.
-- Note: This requires daily aggregation first in a real scenario
			SELECT 
				bill_date, 
				amount,
				AVG(amount) OVER (ORDER BY bill_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg
			FROM billing;
-- 40. **Percentile Ranking:** Use `NTILE(4)` to divide doctors into 4 groups based on their experience (Quartiles: Junior, Mid, Senior, Expert).
			SELECT 
				doctor_id, 
				years_experience,
				NTILE(4) OVER (ORDER BY years_experience) AS experience_quartile
			FROM doctors;
