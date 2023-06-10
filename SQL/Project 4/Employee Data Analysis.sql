-- *****************
-- View Dataset --- 
-- *****************

SELECT 
    *
FROM
    employee_data;
    
-- ********************
-- Cleaning Dataset --- 
-- ********************

-- altering columns to have datatypes that match the data they contain

ALTER TABLE employee_data
MODIFY COLUMN recorddate_key datetime;

ALTER TABLE employee_data
MODIFY COLUMN birthdate_key datetime;

ALTER TABLE employee_data
MODIFY COLUMN orighiredate_key datetime;

ALTER TABLE employee_data
MODIFY COLUMN terminationdate_key datetime;

-- updating job titles to ensure consistency 
UPDATE employee_data
SET job_title = 'Director'
WHERE job_title LIKE '%Director%';

UPDATE employee_data
SET job_title = 'Executive Assistant'
WHERE job_title LIKE '%Exec Ass%';

UPDATE employee_data
SET job_title = 'VP'
WHERE job_title LIKE '%VP%';

UPDATE employee_data
SET job_title = 'Chief Information Officer'
WHERE job_title LIKE 'CHief%';

-- Dropping employees that show up as active and terminated in the same year 
CREATE TEMPORARY TABLE IF NOT EXISTS t_dup_table AS (
    SELECT e.EmployeeID, m.record_date, e.status
FROM
employee_data e
JOIN
(SELECT 
    EmployeeID, MAX(recorddate_key) as record_date, status
FROM
    employee_data
WHERE
        terminationdate_key LIKE '%____-12-31%'
GROUP BY EmployeeID) m on (e.EmployeeID = m.EmployeeID) AND (e.recorddate_key  = m.record_date));

DELETE FROM employee_data
WHERE (EmployeeID, recorddate_key, STATUS) IN (
    SELECT EmployeeID, record_date, STATUS
    FROM t_dup_table
);

-- ***************************************
-- Number of Employees in the Dataset --- 
-- ***************************************

-- Create temporary table to view latest records for all employees
DROP TABLE IF EXISTS t_emp_data;
CREATE TEMPORARY TABLE IF NOT EXISTS t_emp_data
SELECT 
    e.EmployeeID,
    m.record_date,
    e.orighiredate_key AS hire_date,
    e.terminationdate_key AS termination_date,
    e.age,
    e.length_of_service,
    e.city_name,
    e.department_name,
    e.job_title,
    e.store_name,
    e.gender_full AS gender,
    e.termreason_desc AS termination_reason,
    e.termtype_desc AS termination_type,
    e.STATUS_YEAR,
    e.STATUS,
    e.BUSINESS_UNIT
FROM
    employee_data e
        JOIN
    (SELECT 
        EmployeeID, MAX(recorddate_key) AS record_date
    FROM
        Employee_data e
    GROUP BY EmployeeID) m ON (e.EmployeeID = m.EmployeeID)
        AND (e.recorddate_key = m.record_date)
	ORDER BY EmployeeID;

SELECT 
    *
FROM
    t_emp_data;

-- Total Number of Employees
SELECT 
    COUNT(EmployeeID) AS no_of_employees
FROM
    t_emp_data;
    
-- Total Number of Active and Terminated Employees
SELECT 
    status, COUNT(EmployeeID) AS no_of_term_employees
FROM
    t_emp_data
GROUP BY status;

-- Number of Employees grouped by status year and status 
SELECT 
    status_year,
    status,
    COUNT(DISTINCT EmployeeID) AS no_of_employees
FROM
    employee_data
GROUP BY status_year , status;

-- **********************************************************************************
-- Distribution of employees across different cities, departments, and job titles --- 
-- ***********************************************************************************

SELECT 
    city_name,
    COUNT(EmployeeID) AS no_of_employees
FROM
    t_emp_data
GROUP BY city_name 
ORDER BY no_of_employees DESC;

SELECT 
    department_name,
    COUNT(EmployeeID) AS no_of_employees
FROM
    t_emp_data
GROUP BY department_name 
ORDER BY no_of_employees DESC;

SELECT 
    job_title,
    COUNT(EmployeeID) AS no_of_employees
FROM
    t_emp_data
GROUP BY job_title
ORDER BY no_of_employees DESC;

-- ******************************************
-- Overall gender ratio in the workforce --- 
-- ******************************************
SELECT 
     gender,
     COUNT(EmployeeID) AS no_of_employees
FROM
    t_emp_data
GROUP BY gender;

-- ****************************************************
-- Average age and length of service for employees --- 
-- ****************************************************
SELECT 
    CONCAT(ROUND(AVG(age)), ' years') AS average_age,
    CONCAT(ROUND(AVG(length_of_service), 2),
            ' years') AS average_length_of_service
FROM
    t_emp_data;

-- *****************************************************
-- Grouping Employees by Average Length of Service  --- 
-- *****************************************************
SELECT 
    (CASE
        WHEN length_of_service < 12.84 THEN 'Below average'
        ELSE 'Above Average'
    END) AS length_of_service_status,
    COUNT(EmployeeID) AS no_of_employees,
    CONCAT(ROUND((COUNT(EmployeeID) / 6284 * 100), 2),
            '%') AS percentage
FROM
    t_emp_data
GROUP BY length_of_service_status;

-- *************************************************
-- Number of employees terminated in each year--- 
-- *************************************************

-- Create temporary table  for easy reference
DROP TABLE IF EXISTS t_term_emp;
CREATE TEMPORARY TABLE IF NOT EXISTS t_term_emp
SELECT 
    YEAR(terminationdate_key) AS year,
    COUNT(EmployeeID) AS no_of_employees_terminated,
    (SUM(COUNT(EmployeeID)) OVER (ORDER BY YEAR(terminationdate_key))) as total_terminated
FROM
    employee_data
WHERE
    status = 'TERMINATED'
GROUP BY year
ORDER BY year;

-- View Temporary Table 
SELECT 
    *
FROM
    t_term_emp;
    
-- ***********************************
-- Most Common Termination Reasons--- 
-- ***********************************
SELECT 
    termination_reason, 
    COUNT(EmployeeID) AS no_of_employees,
    CONCAT(ROUND((COUNT(EmployeeID)/ 1485) * 100), '%') as percent_reason
FROM
    t_emp_data
WHERE
    termination_reason != 'Not Applicable'
GROUP BY termination_reason
ORDER BY no_of_employees DESC;

-- ***********************************
-- Most Common Termination Type--- 
-- ***********************************
SELECT 
    termination_type, 
    COUNT(EmployeeID) AS no_of_employees,
    CONCAT(ROUND((COUNT(EmployeeID)/ 1485) * 100), '%') as percent_reason
FROM
    t_emp_data
WHERE
    termination_type != 'Not Applicable'
GROUP BY termination_type
ORDER BY no_of_employees DESC;


-- *********************************************************************************************
-- Relationships between employee attributes (age, gender, department) and termination reason -- 
-- *********************************************************************************************


-- gender
SELECT 
    termination_reason,
    gender,
    COUNT(EmployeeID) AS no_of_employees
FROM
    t_emp_data
WHERE
    termination_reason != 'Not Applicable'
GROUP BY termination_reason , gender
ORDER BY termination_reason , gender;


-- business unit
SELECT 
    termination_reason,
    business_unit,
    COUNT(*) AS no_of_employees
FROM
    t_emp_data
WHERE
    termination_reason != 'Not Applicable'
GROUP BY termination_reason , business_unit
ORDER BY termination_reason , business_unit;


-- **********************************************
-- Caluculating Yearly Employee Turnover Rate -- 
-- **********************************************
SELECT 
    a.status_year,
    no_of_active_employees,
    no_of_employees_terminated,
    CONCAT(ROUND((no_of_employees_terminated / no_of_active_employees) * 100,
                    2),
            '%') AS employee_turnover_rate
FROM
    t_active_emp a
        JOIN
    t_term_emp t ON a.status_year = t.year
    WINDOW w as ()
ORDER BY year;

-- *******************************
-- Hiring Trends over the Years--- 
-- ********************************

-- Temporary Table showing the Number of active employees each year
DROP TABLE IF EXISTS t_active_emp;
CREATE TEMPORARY TABLE IF NOT EXISTS t_active_emp
SELECT 
    status_year,
    COUNT(EmployeeID) AS no_of_active_employees
FROM
    employee_data
WHERE
    status = 'ACTIVE'
GROUP BY status_year
ORDER BY status_year;

SELECT 
    *
FROM
    t_active_emp;

-- Calculating Yearly Employee Growth 
SELECT 
    a.status_year,
    no_of_active_employees,
    LAG(no_of_active_employees) over w as no_of_active_emp_prev_yr,
    CONCAT(ROUND(((no_of_active_employees - LAG(no_of_active_employees) over w )/ no_of_active_employees) * 100,
                    2),
            '%') AS employee_growth
FROM
    t_active_emp a
    WINDOW w as ()
ORDER BY status_year;



