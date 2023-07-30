# Exploring Terminated Employee Demographics
- [Introduction](#introduction)
  - [Questions to be Answered](#questions-to-be-answered)
- [Data Cleaning](#data-cleaning)
- [Data Analysis](#data-analysis)



## Introduction
The purpose of this project is to perform data analysis on a dataset containing employee information. By utilizing SQL queries, we aim to gain insights into various aspects of the employees' demographics, employment history, and termination details. This analysis can provide valuable information to human resources departments, management teams, or any stakeholders interested in understanding the composition and dynamics of the employee workforce.

### Target Audience
Human resources departments, management teams, and stakeholders interested in analyzing employee data.

### Questions to be Answered
1. How many employees work or have worked for the company?
2. What is the distribution of employees across different cities, departments, and job titles?
3. What is the overall gender ratio in the workforce?
4. What is the average age and length of service for employees?
5. What percentage of employees have stayed longer than the average length of service?
6. How many employees were terminated each year? What are the most common termination reasons and types?
7. Are there any relationships between employee attributes such as age, gender, or business unit, and the termination reason?
8. How does employee turnover rate change over the years?
9. Are there any company-wide hiring trends over the years?

### Tools 
- mySQL - View [SQL queries](https://github.com/DeborahAkpoguma/Portfolio/blob/main/SQL/Project%204/Employee%20Data%20Analysis.sql) used in this project.
- Tableau - View the dashboard associated with this project [here](https://public.tableau.com/app/profile/deborah.akpoguma/viz/ExploringtheRelationshipbetweenTerminationsandEmployeeDemographicFactors/Dashboard2).

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
  - age (years): The age of the employee. All values were integers. There were no missing values.
  - length of service (years): How long the employee has worked for the company. All values are integers. There were no missing values.
  - city: The location of the store the employee works/worked at. All values are text. There were no missing values.
  - department: The department the employee works/worked in. All values are text. There were no missing values.
  - job title: The job title of the employee. All values are text. There were no missing values.
  - store number: The number of the store the employee works/worked at. All values are integers. There were no missing values.
  - gender: The gender of the employee. All values are text. There were no missing values.
  - termination reason: Reason the employee was terminated. All values are text. There were no missing values. The termination reason for all active employees is 'Not Applicable'.
  - termination type: The type of termination of the employee. All values are text. There were no missing values. The termination type for all active employees is 'Not Applicable'.
  - status year: The year the employee status was recorded. All values are integers. There were no missing values.
  - status: Current employment status of the employee. All values are text. There were no missing values.
  - business unit: The unit the employee works/worked in. All values are text. There were no missing values. 

## Data Cleaning
- The date columns were initially imported as text format, and I have subsequently made the necessary modifications to convert them to the appropriate datetime format.
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
- Inconsistencies were identified in the job-title column, prompting the need for corrective measures. To ensure a standardized and consistent approach, the relevant job titles were modified accordingly.
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
- Employees who have been terminated on the last day of any year (December 31) appeared as both active and terminated for that particular year in the dataset. This duplication occurred because the record dates for their termination status were set to the first day of the relevant month, while the record dates for their active status were set to December 31. Consequently, when selecting Employee IDs based on their latest record dates, these employees erroneously appear as active instead of terminated.

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
  - The dataset comprises multiple records for each employee. To obtain a subset of the dataset with the most recent records for each employee, a query was executed to create a temporary table. The query grouped the data by Employee ID and selected the maximum record date for each group. This temporary table has been created to serve as a foundation for subsequent queries, where it will be utilized to ensure that only the most recent records are considered for analysis.

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
  - __Distribution Across Cities___: The dataset comprises employees, both active and terminated, distributed across a total of 40 cities. Notably, among these cities, the highest number of employees is recorded in Vancouver, amounting to __1392__ employees. On the other hand, Blue River has the distinction of having the smallest employee presence, with only one employee representing the workforce in that particular city.
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

  - __Distribution Across Departments__: The dataset comprises a total of __21__ distinct departments. Among these departments, the one with the highest number of employees is "Meats," with a count of 1252 employees. On the other hand, the department with the fewest number of employees is "Legal," with a minimal count of only 3 employees. It is important to note that this analysis encompasses both active and terminated employees.
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

    
  - __Distribution Across Job Titles__: The dataset comprises a total of __32__ unique job titles. Among these, the job title with the highest number of employees is "Meat Cutter" with a count of __1218__ employees. Conversely, the job titles with the fewest number of employees are "CEO," "Legal Counsel," "Chief Information Officer," and "Dairy Manager," each having only one employee associated with them. It is important to note that this analysis encompasses both active and terminated employees.
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
  Approximately __54.09%__ of employees demonstrate a length of service surpassing the average duration of 12.84 years, while the remaining __45.91%__ exhibit a length of service below this average.
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
  - A temporary table was created to provide a reference for the number of employees who were terminated between the years 2006 and 2015. The dataset includes a total of 1485 terminated employees. Among the specified time frame, the 2014 stands out with the __highest number of terminated employees__, totaling __253__ employees. Conversely, 2013 exhibits the __lowest number of terminated employees__, with a count of __105__ employees.
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
  - The dataset includes termination reasons categorized as Resignation, Retirement, and Layoff. Among these reasons, retirement is found to be the most prevalent termination reason. 
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
  | Resignation         | 385            | 26%            |
  | Layoff             | 215             | 14%            |

- Most Common Termination Types
  - The dataset includes termination types classified as Voluntary and Involuntary, with the prevailing termination type being Voluntary.
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
  - __Relationship Between Age and Termination Reason__
    - Within the demographic breakdown, it is noteworthy that the age group ranging from __20 to 30__ encountered the highest count of layoffs, while individuals in the __60+__ age category experienced the least number of workforce reductions.
    - Furthermore, when examining resignations, the __20 - 30__ age group was found to have the highest volume of departures, whereas the __60+__ age group displayed the fewest resignations.
    - An intriguing observation emerges in relation to retirement as a termination reason, as it exclusively applies to individuals surpassing __50__ years of age.
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
  | Resignation         | < 20      | 5              |
  | Resignation         | 20 - 30   | 266            |
  | Resignation         | 31 - 40   | 61             |
  | Resignation         | 41 - 50   | 30             |
  | Resignation         | 51 - 60   | 21             |
  | Resignation         | 60+       | 2              |
  | Retirement         | 51 - 60   | 294             |
  | Retirement         | 60+       | 591             |

  - __Relationship Between Gender and Termination Reason__
    - There is a comparable occurrence of layoffs between males and females.
    - Females exhibit a higher frequency of resignation and retirement.
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
  | Resignation        | Female | 211             |
  | Resignation        | Male   | 174             |
  | Retirement         | Female | 591             |
  | Retirement         | Male   | 294             |

  - __Relationship Between Business Unit and Termination Reason__
    - The prevalence of all three termination reasons is noticeably higher among employees working in the store locations. Conversely, no instances of employee layoffs have been recorded among those employed at the head office.
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
  | Resignation        | HEADOFFICE    | 1               |
  | Resignation        | STORES        | 384             |
  | Retirement         | HEADOFFICE    | 68              |
  | Retirement         | STORES        | 817             |

__8. How does employee turnover rate change over the years?__ <br>
In terms of employee turnover rates, the year that exhibited the __highest turnover rate__ was 2014, with a percentage of __5.10%__. Conversely, the year with the __lowest turnover rate was 2013__, with a percentage of __2.01%__. These findings align with the outcomes obtained from the analysis of employee terminations by year, wherein it was determined that 2014 witnessed the greatest number of employee terminations, while 2013 recorded the lowest number of employee terminations.
  ```sql
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
  ```
  | status_year | no_of_active_employees | no_of_employees_terminated | employee_turnover_rate |
  |-------------|------------------------|----------------------------|------------------------|
  | 2006        | 4445                   | 134                        | 3.01%                  |
  | 2007        | 4521                   | 162                        | 3.58%                  |
  | 2008        | 4603                   | 164                        | 3.56%                  |
  | 2009        | 4710                   | 142                        | 3.01%                  |
  | 2010        | 4840                   | 123                        | 2.54%                  |
  | 2011        | 4972                   | 110                        | 2.21%                  |
  | 2012        | 5101                   | 130                        | 2.55%                  |
  | 2013        | 5215                   | 105                        | 2.01%                  |
  | 2014        | 4962                   | 253                        | 5.10%                  |
  | 2015        | 4799                   | 162                        | 3.38%                  |

__9. Are there any company-wide hiring trends over the years?__ <br>
The count of active employees within the company exhibited an upward trend from 2006 to 2013, demonstrating a consistent annual increase. However, a noticeable decline was observed in 2014 and 2015, wherein the number of active employees decreased.
  ```sql
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
  ```
  | status_year | no_of_active_employees | no_of_active_emp_prev_yr | employee_growth |
  |-------------|------------------------|--------------------------|-----------------|
  | 2006        | 4445                   | NULL                     | NULL            |
  | 2007        | 4520                   | 4445                     | 1.66%           |
  | 2008        | 4602                   | 4520                     | 1.78%           |
  | 2009        | 4709                   | 4602                     | 2.27%           |
  | 2010        | 4840                   | 4709                     | 2.71%           |
  | 2011        | 4972                   | 4840                     | 2.65%           |
  | 2012        | 5101                   | 4972                     | 2.53%           |
  | 2013        | 5214                   | 5101                     | 2.17%           |
  | 2014        | 4961                   | 5214                     | -5.10%          |
  | 2015        | 4799                   | 4961                     | -3.38%          |
