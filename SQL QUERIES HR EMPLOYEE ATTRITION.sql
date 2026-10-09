/* ==========================================================================
   HR EMPLOYEE ATTRITION: SQL ANALYSIS (Project 2)
   --------------------------------------------------------------------------
   Objective : Analyse HR employee data to understand how many employees
               leave the company (attrition) and how it relates to
               department, job role, overtime, income and tenure.
   Database  : HR
   Table     : hr_employee_attrition (1,470 employees, 35 columns)
   Target    : Attrition (Yes = employee left, No = employee stayed)

   Topics    : Setup, exploration, attrition overview, department analysis,
               income analysis, overtime, job role, tenure
   ========================================================================== */


/* ==========================================================================
   DATABASE & TABLE SETUP
   ========================================================================== */

-- Create the HR database and switch to it.
create database HR;
use HR;

-- Create the employee table with one column per field in the dataset.
-- Whole numbers (ratings, years, rates, income) use INT, text fields use VARCHAR.
-- EmployeeNumber is the PRIMARY KEY, so every employee record is unique.
CREATE TABLE hr_employee_attrition (
    Age INT,
    Attrition VARCHAR(5),
    BusinessTravel VARCHAR(50),
    DailyRate INT,
    Department VARCHAR(50),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(50),
    EmployeeCount INT,
    EmployeeNumber INT PRIMARY KEY,
    EnvironmentSatisfaction INT,
    Gender VARCHAR(20),
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(50),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(30),
    MonthlyIncome INT,
    MonthlyRate INT,
    NumCompaniesWorked INT,
    Over18 VARCHAR(5),
    OverTime VARCHAR(5),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);


/* ==========================================================================
   BASIC EXPLORATION
   ========================================================================== */

-- List the tables in the HR database and confirm hr_employee_attrition exists.
show tables;

-- View all records in the table.
select * from hr_employee_attrition;

-- Q1. What does the data look like?
-- LIMIT 10 returns only the first 10 rows for a quick preview.
SELECT * 
FROM hr_employee_attrition
LIMIT 10;

-- Q2. How many employees are in the dataset?
-- COUNT(*) counts every row, and each row is one employee.
SELECT COUNT(*) AS total_rows
FROM hr_employee_attrition;


/* ==========================================================================
   ATTRITION OVERVIEW
   ========================================================================== */

-- Q3. How many employees have left the company?
-- Filters to Attrition = 'Yes' and counts those rows.
SELECT COUNT(*) AS attrition_count
FROM hr_employee_attrition
WHERE Attrition = 'Yes';

-- Q4. What is the overall attrition rate (%)?
-- The CASE expression gives 1 to every employee who left and 0 to everyone else,
-- so SUM() counts the leavers. Dividing by COUNT(*) and multiplying by 100
-- gives the percentage, rounded to 2 decimal places.
SELECT 
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 2
    ) AS attrition_rate
FROM hr_employee_attrition;


/* ==========================================================================
   DEPARTMENT ANALYSIS
   ========================================================================== */

-- Q5. How many employees work in each department?
-- GROUP BY splits the data by department, sorted from the largest to the smallest.
SELECT Department, COUNT(*) AS employee_count
FROM hr_employee_attrition
GROUP BY Department
ORDER BY employee_count DESC;

-- Q6. Which department has the most employees leaving?
-- Same grouping as Q5, but only employees with Attrition = 'Yes' are counted.
-- Note: this shows the number of leavers, not the rate. A bigger department
-- will naturally have more leavers, so compare it with Q5 for a fair view.
SELECT Department, COUNT(*) AS attrition_count
FROM hr_employee_attrition
WHERE Attrition = 'Yes'
GROUP BY Department
ORDER BY attrition_count DESC;


/* ==========================================================================
   INCOME ANALYSIS
   ========================================================================== */

-- Q7. What is the average monthly income in each department?
-- AVG() per department, rounded to 2 decimals and sorted from highest to lowest.
SELECT 
    Department,
    ROUND(AVG(MonthlyIncome), 2) AS average_monthly_income
FROM hr_employee_attrition
GROUP BY Department
ORDER BY average_monthly_income DESC;

-- Q8. Which 5 job roles have the highest average income?
-- Averages the monthly income per job role, sorts from highest to lowest,
-- and LIMIT 5 keeps only the top 5 roles.
SELECT 
    JobRole,
    ROUND(AVG(MonthlyIncome), 2) AS highest_average_income
FROM hr_employee_attrition
GROUP BY JobRole
ORDER BY highest_average_income DESC
LIMIT 5;


/* ==========================================================================
   OVERTIME ANALYSIS
   ========================================================================== */

-- Q9. How many employees who work overtime have left?
-- Both conditions must be true (AND): the employee works overtime and has left.
-- Note: this is a count, not a rate. To judge the impact of overtime,
-- compare it with the attrition among employees who do not work overtime.
SELECT COUNT(*) AS overtime_attrition
FROM hr_employee_attrition
WHERE OverTime = 'Yes'
  AND Attrition = 'Yes';
  

/* ==========================================================================
   JOB ROLE ANALYSIS
   ========================================================================== */

-- Q10. Which job roles see the most attrition?
-- Counts the employees who left in each job role, sorted from highest to lowest.
SELECT 
    JobRole,
    COUNT(*) AS attrition_count
FROM hr_employee_attrition
WHERE Attrition = 'Yes'
GROUP BY JobRole
ORDER BY attrition_count DESC;


/* ==========================================================================
   TENURE ANALYSIS
   ========================================================================== */

-- Q11. Do employees who leave have a shorter tenure than those who stay?
-- Groups by Attrition (Yes / No) and compares the average years at the company.
SELECT 
    Attrition,
    ROUND(AVG(YearsAtCompany), 2) AS average_years_at_company
FROM hr_employee_attrition
GROUP BY Attrition;


/* ==========================================================================
   END OF ANALYSIS
   ========================================================================== */
