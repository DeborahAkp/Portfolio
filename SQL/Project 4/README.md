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
7. How does employee turnover rate change over the years?
8. Are there any relationships between employee attributes such as age, gender, or job title, and the termination reason?
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

## Data Analysis

__1. How many employees work or have worked for the company?__ <br>
The dataset contains multiple records for each employee from 2006 to 2015. The following query was used to determine the number of distinct employees - active and terminated - contained in the dataset.
```sql 
SELECT 
    COUNT(DISTINCT EmployeeID) AS no_of_employees
FROM
    employee_data;
```

There are __6,284__ unique employees in the dataset. 
| no_of_employees |
|-----------------|
| 6284            |

Number of Active and Terminated Employees Between 2006 and 2015
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


The following query was used to select the most recent record (2015) for each employee. The data was grouped by Employee ID and the max record date was selected. A temporary table was created using this query and was used in other queries in this project. 
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
  The average age of employees(active and terminated) is __38 years__ and the average length of service is approximately __6.02 years__.
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
  | 38 years    | 6.02 years                |

__5. What percentage of employees have stayed longer than the average length of service?__ <br>
  __46.09%__ of employees have a length of service above the average (12.84 years) length of service and __53.91%__ of employees have a length of service below the average.
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
  | Above Average            | 2896            | 46.09%     |
  | Below average            | 3388            | 53.91%     |

__6. How many employees were terminated in each year? What are the most common termination reasons and types?__ <br>
- Employees Terminated Each Year 
```sql

```
- Most Common Termination Reasons
```sql

```
- Most Common Termination Types
```sql

```
__7. How does employee turnover rate change over the years?__ <br>
```sql

```
__8. Are there any relationships between employee attributes such as age, gender, or job title, and the termination reason?__ <br>

__Relationship Betweeen Age and Termination Reason__
```sql

```
__Relationship Betweeen Gender and Termination Reason__
```sql

```
__Relationship Betweeen Job Title and Termination Reason__
```sql

```

__9. Are there any company-wide hiring trends over the years?__ <br>
```sql

```
