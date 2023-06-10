# Exploring Employee Data
- [Introduction](#introduction)
  - [Questions to be Answered](#questions-to-be-answered)
- [Data Cleaning](#data-cleaning)
- [Data Analysis](#data-analysis)


## Introduction
The purpose of this project is to perform data analysis on a dataset containing employee information. By utilizing SQL queries, we aim to gain insights into various aspects of the employees' demographics, employment history, and termination details. This analysis can provide valuable information to human resources departments, management teams, or any stakeholders interested in understanding the composition and dynamics of the employee workforce.

### Target Audience
Human resources departments, management teams, and stakeholders interested in analyzing employee data.

### Questions to be Answered:
1. How many employees work or have worked for the company?
2. What is the distribution of employees across different cities, departments, and job titles?
3. What is the overall gender ratio in the workforce?
4. What is the average age and length of service for employees?
5. What percentage of employees have stayed longer than the average length of service?
6. How many employees were terminated in each year? What are the most common termination reasons and types?
7. Are there any relationships between employee attributes such as age, gender, or business unit, and the termination reason?
8. How does employee turnover rate change over the years?
9. Are there any company-wide hiring trends over the years?

### Tools 
- mySQL - View [SQL queries](https://github.com/DeborahAkpoguma/Portfolio/blob/main/SQL/Project%204/Employee%20Data%20Analysis.sql) used in this project.

### Portfolio
View other [projects](https://github.com/DeborahAkpoguma/Portfolio-Guide/blob/main/README.md) that I have completed.

### Data 
- The data used in this project can be found [here](https://www.kaggle.com/datasets/HRAnalyticRepository/employee-attrition-data).
- There are 17 columns in this dataset
  - employee id: The ID of the employee. Values are integers. There are no missing values.
  - employee record date: The date the record was collected. All values are datetime. There were no missing values.
  - birth date: The birth date of the employee. All values were imported as text and converted to datetime. There were no missing values.
  - hire date: The date the employee was hired. All values were imported as text and converted to datetime. There were no missing values.
  - termination date: The employee's last day of work. All values were imported as text and converted to datetime. There were no missing values. All active employees have a termination date of '1900-01-01'.
  - age (years): The age of the employee. All values ware integers. There were no missing values.
  - length of service (years): How long the employee has worked for the company. All values are integers. There were no missing values.
  - city: The location of the store the employee works/worked at. All values are text. There were no missing values.
  - department: The department the employee works/worked in. All values are text. There were no missing values.
  - job title: The job title of the employee. All values are text. There were no missing values.
  - store number: The number of the store the employee works/worked at. All values are integers. There were no missing values.
  - gender: The gender of the employee. All values are text. There were no missing values.
  - termination reason: Reason the employee was terminated. All values are text. There were no missing values. The termination reason for all active employees is 'Not Applicable'.
  - termination type: The type of termination of the employee. All values are text. There were no missing values. The termination type for all active employees is 'Not Applicable'.
  - status year: The year the employee status was recorded. All values are integer. There were no missing values.
  - status: Current employment status of the employee. All values are text. There were no missing values.
  - business unit: The unit the employee works/worked in. All values are text. There were no missing values. 

## Data Cleaning
- The date columns were imported as text, I modified them to be datetime.
```sql 
ALTER TABLE employee_data
MODIFY COLUMN recorddate_key datetime;

ALTER TABLE employee_data
MODIFY COLUMN birthdate_key datetime;

ALTER TABLE employee_data
MODIFY COLUMN orighiredate_key datetime;

ALTER TABLE employee_data
MODIFY COLUMN terminationdate_key datetime;
```
- There were inconsitencies in the job-title column. I modified the applicable job titles to ensure consistency. 

```sql 
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
```
- Employees who have been terminated on the last day of any year (December 31) are appeared as both active and terminated for that particular year in the dataset. This duplication occured because the record dates for their termination status were set to the first day of the relevant month, while the record dates for their active status were set to December 31. Consequently, when selecting Employee IDs based on their latest record dates, these employees erroneously appear as active instead of terminated.

  To address this issue, it was necessary to take the following action: the latest records for employee IDs 3008, 3401, 7007, 7023, and 8296 were deliberately removed. By doing so, their status is correctly reflected as "terminated" during subsequent analysis.

  ```sql
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
  ```

## Data Analysis

__1. How many employees work or have worked for the company?__ <br>
  - The dataset contains multiple records for each employee. The following query was used to create a temporary table that displays the most recent records for each employee. The data was grouped by Employee ID and the max record date was selected. This table will be used in subsequent queries. 

  ```sql
  DROP TABLE IF EXISTS t_emp_data;
  CREATE TEMPORARY TABLE IF NOT EXISTS t_emp_data
  SELECT 
      EmployeeID,
      MAX(recorddate_key) AS record_date,
      orighiredate_key AS hire_date,
      terminationdate_key AS termination_date,
      age,
      length_of_service,
      city_name,
      department_name,
      job_title,
      store_name,
      gender_full AS gender,
      termreason_desc AS termination_reason,
      termtype_desc AS termination_type,
      STATUS_YEAR,
      STATUS,
      BUSINESS_UNIT
  FROM
      employee_data
  GROUP BY EmployeeID;
```
- The following queries were used to determine the number of unique employees - active and terminated - contained in the dataset.
    ```sql 
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

    -- Number of Employees grouped by status year and status --- 
    SELECT 
        status_year,
        status,
        COUNT(DISTINCT EmployeeID) AS no_of_employees
    FROM
        employee_data
    GROUP BY status_year , status;
    ```

    There are __6,284__ unique employees in the dataset. 
    | no_of_employees |
    |-----------------|
    | 6284            |
    
    There are __4799 active employees__ and __1485 terminated employees__ contained in the dataset. 
    
    | status     | no_of_term_employees |
    |------------|----------------------|
    | ACTIVE     | 4799                 |
    | TERMINATED | 1485                 |

    __Number of Active and Terminated Employees Between 2006 and 2015__
    | status_year | status     | no_of_employees |
    |-------------|------------|-----------------|
    | 2006        | ACTIVE     | 4445            |
    | 2006        | TERMINATED | 134             |
    | 2007        | ACTIVE     | 4521            |
    | 2007        | TERMINATED | 162             |
    | 2008        | ACTIVE     | 4603            |
    | 2008        | TERMINATED | 164             |
    | 2009        | ACTIVE     | 4710            |
    | 2009        | TERMINATED | 142             |
    | 2010        | ACTIVE     | 4840            |
    | 2010        | TERMINATED | 123             |
    | 2011        | ACTIVE     | 4972            |
    | 2011        | TERMINATED | 110             |
    | 2012        | ACTIVE     | 5101            |
    | 2012        | TERMINATED | 130             |
    | 2013        | ACTIVE     | 5215            |
    | 2013        | TERMINATED | 105             |
    | 2014        | ACTIVE     | 4962            |
    | 2014        | TERMINATED | 253             |
    | 2015        | ACTIVE     | 4799            |
    | 2015        | TERMINATED | 162             |



__2. What is the distribution of employees across different cities, departments, and job titles?__
  - __Distribution Across Cities___: Employees (active and terminated) are located in __40__ cities. The city with the most employees is __Vancouver__ (1392) and the city with the least employees is __Blue River__ (1).  
    ```sql
     SELECT 
        city_name,
        COUNT(EmployeeID) AS no_of_employees
    FROM
        t_emp_data
    GROUP BY city_name 
    ORDER BY no_of_employees DESC;
     ``` 
    __Top 5 Cities with the Most Employees__
    | city_name       | no_of_employees |
    |-----------------|-----------------|
    | Vancouver       | 1392            |
    | Victoria        | 624             |
    | Nanaimo         | 481             |
    | New Westminster | 403             |
    | Kelowna         | 305             |

    __Top 5 Cities with the Fewest Employees__
    | city_name     | no_of_employees |
    |---------------|-----------------|
    | Blue River    | 1               |
    | Dease Lake    | 2               |
    | Valemount     | 5               |
    | Cortes Island | 6               |
    | Ocean Falls   | 7               |

  - __Distribution Across Departments__: There are __21__ departments listed in the dataset. The department with the most employees is __Meats__ (1252) and the deparment with the least employees is __Legal__ (3). This analysis includes active and terminated employees. 
    ```sql
    SELECT 
        department_name,
        COUNT(EmployeeID) AS no_of_employees
    FROM
        t_emp_data
    GROUP BY department_name 
    ORDER BY no_of_employees DESC;
    ```
    __Top 5 Departments with the Most Employees__
    | department_name  | no_of_employees |
    |------------------|-----------------|
    | Meats            | 1252            |
    | Customer Service | 1190            |
    | Produce          | 1060            |
    | Dairy            | 1033            |
    | Bakery           | 898             |
    
    __Top 5 Departments with the Least Employees__
    | department_name  | no_of_employees |
    |------------------|-----------------|
    | Legal            | 3               |
    | Investment       | 4               |
    | Compensation     | 4               |
    | Audit            | 4               |
    | Accounts Payable | 4               |

    
  - __Distribution Across Job Titles__: There are __32__ job titles listed in the dataset. The job title held by the most employees is __Meat Cutter__ (1218) and the job titles held by fewest employees are __CEO__ (1), __Legal Counsel__ (1), __Chief Informatin Officer__ (1), and __Dairy Manager__ (1). This analysis includes active and terminated employees.
      ```sql
    SELECT 
        job_title,
        COUNT(EmployeeID) AS no_of_employees
    FROM
        t_emp_data
    GROUP BY job_title
    ORDER BY no_of_employees DESC;  
       ```
    
    __Top 5 Job Titles Held by the Most Employees__
    | job_title     | no_of_employees |
    |---------------|-----------------|
    | Meat Cutter   | 1218            |
    | Cashier       | 1158            |
    | Dairy Person  | 1032            |
    | Produce Clerk | 1027            |
    | Baker         | 865             |

    __Top 5 Job Titles Held by the Least Employees__
    | job_title                 | no_of_employees |
    |---------------------------|-----------------|
    | CEO                       | 1               |
    | Dairy Manager             | 1               |
    | Legal Counsel             | 1               |
    | Chief Information Officer | 1               |
    | Investment Analyst        | 3               |
  
 __3. What is the overall gender ratio in the workforce?__
  There are __3006 males__ and __3278 females__ in the workforce. <br>
   ```sql
    SELECT 
         gender, 
         COUNT(EmployeeID) AS no_of_employees
    FROM
        t_emp_data
  GROUP BY gender;
   ```
   | gender | no_of_employees |
   |--------|-----------------|
   | Male   | 3006            |
   | Female | 3278            |
   
__4. What is the average age and length of service for employees?__ <br>
  The average age of employees(active and terminated) is __45 years__ and the average length of service is approximately __12.84 years__.
  ```sql
  SELECT 
      CONCAT(ROUND(AVG(age)), ' years') AS average_age,
      CONCAT(ROUND(AVG(length_of_service), 2),
              ' years') AS average_length_of_service
  FROM
      t_emp_data;
  ```
  | average_age | average_length_of_service |
  |-------------|---------------------------|
  | 45 years    | 12.84 years               |

__5. What percentage of employees have stayed longer than the average length of service?__ <br>
  __54.09%__ of employees have a length of service above the average (12.84 years) length of service and __45.91%__ of employees have a length of service below the average.
  ```sql
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
  ```
  | length_of_service_status | no_of_employees | percentage |
  |--------------------------|-----------------|------------|
  | Above Average            | 3399            | 54.09%     |
  | Below average            | 2885            | 45.91%     |

__6. How many employees were terminated in each year? What are the most common termination reasons and types?__ <br>
- Employees Terminated Each Year 
  - The following temporary table was created to reference the number of employees terminated between 2006 and 2015. There are a total of __1485 terminated employees__ in the dataset. 2014 is the year with the __most terminated employees (253)__ and 2013 is the year with the __least terminated employees (105)__.
    ```sql
    DROP TABLE IF EXISTS t_term_emp;
    CREATE TEMPORARY TABLE IF NOT EXISTS t_term_emp
    SELECT 
        YEAR(terminationdate_key) AS year,
        COUNT(EmployeeID) AS no_of_employees_terminated
    FROM
        employee_data
    WHERE
        status = 'TERMINATED'
    GROUP BY year
    ORDER BY year;
    ```
    | year | no_of_employees_terminated | total_terminated |
    |------|----------------------------|------------------|
    | 2006 | 134                        | 134              |
    | 2007 | 162                        | 296              |
    | 2008 | 164                        | 460              |
    | 2009 | 142                        | 602              |
    | 2010 | 123                        | 725              |
    | 2011 | 110                        | 835              |
    | 2012 | 130                        | 965              |
    | 2013 | 105                        | 1070             |
    | 2014 | 253                        | 1323             |
    | 2015 | 162                        | 1485             |


- Most Common Termination Reasons
  - The termination reasons listed in the dataset are Resignation, Retirement, and Layoff with the most common termination reason being retirement.  
  ```sql
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
  ```
  | termination_reason | no_of_employees | percent_reason |
  |--------------------|-----------------|----------------|
  | Retirement         | 885             | 60%            |
  | Resignaton         | 385             | 26%            |
  | Layoff             | 215             | 14%            |

- Most Common Termination Types
  - The termination types provided in the dataset are Voluntary and Involuntary with the most common termination type being Voluntary.
  ```sql
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
  ```
  | termination_type | no_of_employees | percent_reason |
  |------------------|-----------------|----------------|
  | Voluntary        | 1270            | 86%            |
  | Involuntary      | 215             | 14%            |


__7. Are there any relationships between employee attributes such as age, gender, or business unit, and the termination reason?__ <br>
  - __Relationship Betweeen Age and Termination Reason__
    - The __20 - 30__ age group had the most number of layoffs and the __60+__ age group had the least number of layoffs.
    - The __20 - 30__ age group had the most number of resignations and the __60+__ age group had the least number of resignations.
    - Only people over __50__ years of age have retirement as a termination reason.
  ```sql
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
  GROUP BY termination_reason , age_group
  ORDER BY termination_reason , age_group;
  ```
  | termination_reason | age_group | no_of_employees |
  |--------------------|-----------|-----------------|
  | Layoff             | 20 - 30   | 61              |
  | Layoff             | 31 - 40   | 53              |
  | Layoff             | 41 - 50   | 41              |
  | Layoff             | 51 - 60   | 34              |
  | Layoff             | 60+       | 26              |
  | Resignaton         | < 20      | 5               |
  | Resignaton         | 20 - 30   | 266             |
  | Resignaton         | 31 - 40   | 61              |
  | Resignaton         | 41 - 50   | 30              |
  | Resignaton         | 51 - 60   | 21              |
  | Resignaton         | 60+       | 2               |
  | Retirement         | 51 - 60   | 294             |
  | Retirement         | 60+       | 591             |

  - __Relationship Betweeen Gender and Termination Reason__
    - The frequency of layoffs between males and females is similar.
    - Females have a higher frequency of resignation and retirement.
  ```sql
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
  ```
  | termination_reason | gender | no_of_employees |
  |--------------------|--------|-----------------|
  | Layoff             | Female | 113             |
  | Layoff             | Male   | 102             |
  | Resignaton         | Female | 211             |
  | Resignaton         | Male   | 174             |
  | Retirement         | Female | 591             |
  | Retirement         | Male   | 294             |

  - __Relationship Betweeen Business Unit and Termination Reason__
    - All three termination reasons are more common for employees that work in the stores. No employees that work in the headoffice have been layed off. 
  ```sql
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
  ```
  | termination_reason | business_unit | no_of_employees |
  |--------------------|---------------|-----------------|
  | Layoff             | STORES        | 215             |
  | Resignaton         | HEADOFFICE    | 1               |
  | Resignaton         | STORES        | 384             |
  | Retirement         | HEADOFFICE    | 68              |
  | Retirement         | STORES        | 817             |


__8. How does employee turnover rate change over the years?__ <br>
```sql

```

__9. Are there any company-wide hiring trends over the years?__ <br>
```sql

```
