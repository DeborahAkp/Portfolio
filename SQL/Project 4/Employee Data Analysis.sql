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


-- ***************************************
-- Number of Employees in the Dataset --- 
-- ***************************************

SELECT 
    COUNT(DISTINCT EmployeeID) AS no_of_employees
FROM
    employee_data;
    
-- *********************************************
-- Number of Terminated Employees in the Dataset --- 
-- *********************************************
SELECT 
    COUNT(DISTINCT EmployeeID) AS no_of_employees
FROM
    employee_data
WHERE
    status = 'Terminated';

-- Create temporary table to view distinct employee information 
DROP TABLE IF EXISTS t_emp_data;
CREATE TEMPORARY TABLE IF NOT EXISTS t_emp_data
SELECT 
    e.EmployeeID,
    e.orighiredate_key AS hire_date,
    e.terminationdate_key AS termination_date,
    e.age,
    length_of_service,
    e.city_name,
    e.department_name,
    e.job_title,
    e.store_name,
    e.gender_full,
    e.termreason_desc AS termination_reason,
    e.termtype_desc AS termination_type,
    e.STATUS_YEAR,
    e.STATUS,
    e.BUSINESS_UNIT
FROM
    employee_data e
JOIN (
    SELECT EmployeeID, MAX(length_of_service) AS max_length_of_service
    FROM employee_data
    GROUP BY EmployeeID) m ON e.EmployeeID = m.EmployeeID and max_length_of_service = e.length_of_service
GROUP BY EmployeeID;


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
    gender_full AS gender, 
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

-- Create temporary table to for easy reference
DROP TABLE IF EXISTS t_term_emp;
CREATE TEMPORARY TABLE IF NOT EXISTS t_term_emp
SELECT 
    YEAR(termination_date) AS year,
    COUNT(EmployeeID) AS no_of_employees_terminated
FROM
    t_emp_data
WHERE
    termination_date != '1900-01-01'
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
    termreason_desc as termination_reason, COUNT(EmployeeID) AS no_of_employees
FROM
    employee_data
WHERE
     ttermreason_desc  != 'Not Applicable'
GROUP BY termreason_desc
ORDER BY no_of_employees DESC;

-- ***********************************
-- Most Common Termination Type--- 
-- ***********************************
SELECT 
    termination_type, COUNT(EmployeeID) AS no_of_employees
FROM
    t_emp_data
WHERE
    termination_type != 'Not Applicable'
GROUP BY termination_type
ORDER BY no_of_employees DESC;

-- *********************************************************************************************
-- Relationships between employee attributes (age, gender, department) and termination reason -- 
-- *********************************************************************************************
SELECT 
    termination_reason,
    (CASE
        WHEN age < 20 THEN '< 20'
        WHEN age BETWEEN 20 AND 30 THEN '20 - 30'
        WHEN age BETWEEN 31 AND 40 THEN '31 - 40'
        WHEN age BETWEEN 41 AND 50 THEN '41 - 50'
        WHEN age BETWEEN 51 AND 60 THEN '51 - 60'
        WHEN age > 60 THEN '60+'
    END) AS age_group,
    COUNT(*) AS no_of_employees
FROM
    t_emp_data
WHERE
    termination_reason != 'Not Applicable'
GROUP BY termination_reason, age_group
ORDER BY termination_reason, age_group;

-- gender
SELECT 
    termination_reason, gender_full, COUNT(EmployeeID) AS no_of_employees
FROM
    t_emp_data
WHERE
    termination_reason != 'Not Applicable'
GROUP BY termination_reason , gender_full
ORDER BY termination_reason , gender_full;

-- department
SELECT 
    termination_reason,
    department_name,
    COUNT(*) AS no_of_employees
FROM
    t_emp_data
WHERE
    termination_reason != 'Not Applicable'
GROUP BY termination_reason , department_name
ORDER BY termination_reason , department_name;

-- *************************************************
-- Number of active employees  each year--- 
-- *************************************************

-- Create temporary table to for easy reference
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


-- *************************************************
-- Number of employees hired each year--- 
-- *************************************************

DROP TABLE IF EXISTS t_hired_emp;
CREATE TEMPORARY TABLE IF NOT EXISTS t_hired_emp
SELECT 
    YEAR(hire_date) AS year,
    COUNT(EmployeeID) AS no_of_employees_hired
FROM
    t_emp_data
GROUP BY year
ORDER BY year;

-- View Temporary Table 
SELECT 
    *
FROM
    t_hired_emp;
    




-- *********************************************
-- Caluculating Yearly Employee Turnover Rate and Head Count Growth -- 
-- ********************************************
SELECT 
    a.status_year,
    no_of_active_employees,
    LAG(no_of_active_employees) over w as no_of_active_emp_prev_yr,
    CONCAT(ROUND(((no_of_active_employees - LAG(no_of_active_employees) over w )/ no_of_active_employees) * 100,
                    2),
            '%') AS employee_growth,
    no_of_employees_terminated,
    CONCAT(ROUND((no_of_employees_terminated / no_of_active_employees) * 100,
                    2),
            '%') AS employee_turnover_rate
FROM
    t_active_emp a
        JOIN
    t_term_emp t ON a.status_year = t.year
    WINDOW w as ()
ORDER BY status_year;



-- Ordered by turnover 

SELECT 
    a.status_year,
    no_of_active_employees,
    LAG(no_of_active_employees) over w as no_of_active_emp_prev_yr,
    CONCAT(ROUND(((no_of_active_employees - LAG(no_of_active_employees) over w )/ no_of_active_employees) * 100,
                    2),
            '%') AS employee_growth,
    no_of_employees_terminated,
    CONCAT(ROUND((no_of_employees_terminated / no_of_active_employees) * 100,
                    2),
            '%') AS employee_turnover_rate
FROM
    t_active_emp a
        JOIN
    t_term_emp t ON a.status_year = t.year
    WINDOW w as ()
ORDER BY employee_turnover_rate DESC;

-- Ordered by head count increase

SELECT 
    a.status_year,
    no_of_active_employees,
    LAG(no_of_active_employees) over w as no_of_active_emp_prev_yr,
    CONCAT(ROUND(((no_of_active_employees - LAG(no_of_active_employees) over w )/ no_of_active_employees) * 100,
                    2),
            '%') AS employee_growth,
    no_of_employees_terminated,
    CONCAT(ROUND((no_of_employees_terminated / no_of_active_employees) * 100,
                    2),
            '%') AS employee_turnover_rate
FROM
    t_active_emp a
        JOIN
    t_term_emp t ON a.status_year = t.year
    WINDOW w as ()
ORDER BY employee_growth DESC;
