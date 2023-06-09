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

There are __5,336__ active and __948__ terminated employees.
| status     | no_of_employees |
|------------|-----------------|
| ACTIVE     | 5336            |
| TERMINATED | 948             |

The following query was used to select the most recent record for each employee. The data was grouped by Employee ID and the max record date was selected. A temporary table was created using this query and was used in other queries in this project. 
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
  - Distribution Across Cities
    ```sql
  
     ```
  - Distribution Across Departments
    ```sql
  
    ``` 
  - Distribution Across Job Titles
      ```sql
  
       ```
 ```sql
  
 ```
