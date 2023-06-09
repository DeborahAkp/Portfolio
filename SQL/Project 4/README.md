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
- mySQL - View [SQL queries](https://github.com/DeborahAkpoguma/Portfolio/blob/main/SQL/Project%204/Employee%20Data%20Analysis.sql) generated for this project.

### Data 
The data used in this project can be found [here](https://www.kaggle.com/datasets/HRAnalyticRepository/employee-attrition-data).

### Portfolio
View other [projects](https://github.com/DeborahAkpoguma/Portfolio-Guide/blob/main/README.md) that I have completed.

## Data Cleaning

```sql 
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
```

## Data Analysis
```sql 

```
