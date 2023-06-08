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

ALTER TABLE employee_data
MODIFY COLUMN birthdate_key datetime;


ALTER TABLE employee_data
MODIFY COLUMN orighiredate_key datetime;

ALTER TABLE employee_data
MODIFY COLUMN terminationdate_key datetime;

ALTER TABLE employee_data
MODIFY COLUMN age int;

ALTER TABLE employee_data
MODIFY COLUMN length_of_service int;

ALTER TABLE employee_data
MODIFY COLUMN store_name int;

ALTER TABLE employee_data
MODIFY COLUMN STATUS_YEAR int;

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

SELECT DISTINCT
    job_title, COUNT(job_title)
FROM
    employee_data
GROUP BY job_title;

-- **********************************************************************************
-- Distribution of employees across different cities, departments, and job titles --- 
-- ***********************************************************************************
SELECT 
    city_name,
    department_name,
    job_title,
    COUNT(*) AS no_of_employees
FROM
    employee_data
GROUP BY city_name , department_name, job_title
ORDER BY city_name , department_name, job_title;

-- ******************************************
-- Overall gender ratio in the workforce --- 
-- ******************************************
SELECT 
    gender_full AS gender, 
    COUNT(*) AS no_of_employees
FROM
    employee_data
GROUP BY gender;

-- ****************************************************
-- Average age and length of service for employees --- 
-- ****************************************************
SELECT 
    CONCAT(ROUND(AVG(age)), ' years') AS average_age,
    CONCAT(ROUND(AVG(length_of_service), 2),
            ' years') AS average_length_of_service
FROM
    employee_data;


-- ******************************************************************
-- Employees with the longest and shortest tenure in the company --- 
-- ******************************************************************

-- Longest Tenure

SELECT 
    EmployeeID,
    orighiredate_key AS hire_date,
    terminationdate_key AS termination_date,
    length_of_service
FROM
    employee_data
ORDER BY length_of_service DESC;

-- Shortest Tenure

SELECT 
    EmployeeID,
    orighiredate_key AS hire_date,
    terminationdate_key AS termination_date,
    length_of_service
FROM
    employee_data
ORDER BY length_of_service;

-- *************************************************
-- Number of employees terminated in each year--- 
-- *************************************************
SELECT 
    YEAR(terminationdate_key) AS year,
    COUNT(*) AS no_of_employees_terminated
FROM
    employee_data
WHERE
    YEAR(terminationdate_key) != 1900
GROUP BY year
ORDER BY year;

-- ***********************************
-- Most Common Termination Reasons--- 
-- ***********************************
SELECT 
    termreason_desc AS termination_reason,
    COUNT(*) AS no_of_employees
FROM
    employee_data
WHERE
    termreason_desc != 'Not Applicable'
GROUP BY termreason_desc
ORDER BY no_of_employees DESC;

-- ***********************************
-- Most Common Termination Type--- 
-- ***********************************
SELECT 
    termtype_desc AS termination_type,
    COUNT(*) AS no_of_employees
FROM
    employee_data
WHERE
    termtype_desc != 'Not Applicable'
GROUP BY termtype_desc
ORDER BY no_of_employees DESC;

-- ********************************************************************************************
-- Relationships between employee attributes (age, gender, department) and termination type -- 
-- ********************************************************************************************
SELECT 
    termreason_desc AS termination_reason,
    age,
    COUNT(*) AS no_of_employees
FROM
    employee_data
WHERE
    termreason_desc != 'Not Applicable'
GROUP BY termination_reason , age
ORDER BY termination_reason , age;

-- gender
SELECT 
    termreason_desc AS termination_reason,
    gender_full,
    COUNT(*) AS no_of_employees
FROM
    employee_data
WHERE
    termreason_desc != 'Not Applicable'
GROUP BY termination_reason , gender_full
ORDER BY termination_reason , gender_full;

-- department
SELECT 
    termreason_desc AS termination_reason,
    department_name,
    COUNT(*) AS no_of_employees
FROM
    employee_data
WHERE
    termreason_desc != 'Not Applicable'
GROUP BY termination_reason , department_name
ORDER BY termination_reason , department_name;




