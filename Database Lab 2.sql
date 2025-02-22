--21k3445 Adnan Haider Database lab 2

--Display any two columns from employees table
select employee_id, salary from employees;

--Display Hire_date from employees table, name it as Joining Date.
select hire_date from employees;

--Display the first_name, last_name of Employees together in one column named “FULL NAME”
select first_name || ' ' || last_name as "FULL NAME" from employees;


--Row Selection Using WHERE Clause:
--1. List all Employees having annual salary greater 20, 000 and lesser than 30,000.
select * from employees 
where salary*12 > 20000 
and salary*12 < 30000;

--2. List employee_id and first_name of employees from department 60 to department 100.
select employee_id, first_name from employees
where department_id between 60 and 100;

--3. List all the Employees having an ‘ll’ in their first_names.
select * from employees
where first_name like '%ll%';

--4. List all the employees with no commission.
select * from employees
where commission_pct is null;


--Sorting Rows with Order by Clause:
--1. List all employees in order of their decreasing salaries.
select * from employees
order by salary desc;


--Numeric Functions:
--1. Find the absolute values of the salary differences between salary and a base amount of 5000 for employees with IDs 100 and 101
select abs(5000-salary) from employees
where EMPLOYEE_ID in (100, 101);

--2. Round the salary of employees to the nearest whole number and to 2 decimal places.
select round(salary,0), round(salary,2) from employees;

--3. Find the ceiling value of the salary of employees, showing how it rounds up to the nearest whole number.
select ceil(salary) as ceiling_salary from employees;

--4. Find the floor value of the salary of employees, showing how it rounds down to the nearest whole number.
select floor(salary) as flooring_salary from employees;

--5. Find the highest value between salary and commission_pct (converted to a percentage) for each employee. Assume that commission_pct is a percentage value.
SELECT salary, commission_pct,
    GREATEST(salary, salary * commission_pct) AS highest_value
FROM employees;

--6. Find the lowest value between salary and commission_pct (converted to a percentage) for each employee. Assume that commission_pct is a percentage value.
SELECT salary, commission_pct,
    LEAST(salary, salary * commission_pct) AS highest_value
FROM employees;


--Character or Text Functions:
--1. Concatenate the department_name and location_id from the departments table to create a string in the format 'Department: [department_name] Location: [location_id]'.
select 'Department: [' || department_name || '] Location: [' || location_id || ']' from departments;

--2. Extract the first 4 characters of each job_title in the jobs table.
select job_title, substr(job_title,1,4) from jobs;

--3. Find the length of the street_address field for each location in the locations table.
select street_address, length(street_address) from locations;

--4. Convert all employees first name into uppercase
select upper(first_name) from employees;

--5. Convert all email addresses to lowercase in the employees table.
select lower(EMAIL) from employees;

--6. Convert the department_name field to title case, where the first letter of each word is capitalized.
select initcap(department_name) from departments;

--7. Remove leading and trailing spaces from the first_name field, then convert it to UPPERCASE.
select upper( rtrim( ltrim( first_name, ' '), ' ')) from employees;

--8. Pad the Salary field with leading zeros from left and right both sides separately so that all salary amount have a length of 7 characters
select salary, lpad(salary, 7, 0) as LeftPadding, rpad(salary, 7, 0) as RightPadding  from employees;


--Date Functions:
--1. Display the Current Date.
SELECT SYSDATE FROM dual;

--2. Calculate the Number of Months Between Today and Each Employee’s Hire Date.
select months_between(SYSDATE, hire_date) from employees;

--3. Find the Next Monday After Each Employee’s Hire Date.
select next_day(hire_date, 'monday') from employees;

--4. Find the Last Day of the Month for Each Employee’s Hire Date
select last_day(hire_date) from employees;

--Conversion Functions:
--1) Print an employee name (first letter capital) and job_title (lower Case)
select initcap(first_name), lower(job_id) from employees;

--2) For all employees employed for more than 100 months, display the employee number, hire date,number of months employed, first Friday after hire date and last day of the month hired.
select EMPLOYEE_ID, hire_date, months_between(SYSDATE, hire_date), next_day(hire_date, 'friday'), last_day(hire_date) from employees
where months_between(SYSDATE, hire_date) > 100;

--3) Comparing the hire dates for all employees who started in 2003, display the employee number, hire date, and month started using the conversion and date functions.
select employee_id, to_date(hire_date) , to_char(hire_date, 'Month') from employees
where to_char(hire_date, 'yyyy') = 2003;

--4) To display the employee number, the month number and year of hiring.
select employee_id, to_char(hire_date, 'mm'), to_char(hire_date, 'yyyy') from employees;

--5) To display the employee name and hire date for all employees. The hire date appears as 16September, 2021.
select first_name ||' '|| last_name as "NAME", to_char(hire_date, 'DDfmMonth, YYYY') from employees;

--6) Display the salary of employee STEVEN with $ sign preceded.
select '$' || salary from employees
where first_name = 'Steven';

--7) Find the next ‘Monday’ considering today’s date as date.
select next_day(SYSDATE, 'monday') from dual;

--8) List all Employees who have an ‘A’ in their last names.
select * from employees
where first_name like '%A%';

--9) Show all employees’ last three letters of first name
select SUBSTR(first_name, -3) as LAST3Letters, first_name from employees;


--Tasks:
--1) To display the employee number, name, salary of employee before and after 15% increment in the
--yearly salary. Name the calculated new salary as “Incremented Salary”. Do calculate the difference
--between two salaries. Name the increased amount to be “Incremented Amount”.
select employee_id, first_name||' '|| last_name as "Full_Name", 
salary*12 as "Before_Increment",
(salary*12)*1.15 as "Incremented_Salary",
(salary*12)*1.15 - salary*12 as "Incremented_Amount"
from employees;

--2) List the name, hire date, and day of the week (labeled DAY) on which job was started. Order the resultby day of week starting with Monday.
SELECT first_name,
       hire_date,
       TO_CHAR(hire_date, 'Day') AS DAY
FROM employees
ORDER BY 
    CASE TO_CHAR(hire_date, 'Day')
        WHEN 'Monday   ' THEN 1
        WHEN 'Tuesday  ' THEN 2
        WHEN 'Wednesday' THEN 3
        WHEN 'Thursday ' THEN 4
        WHEN 'Friday   ' THEN 5
        WHEN 'Saturday ' THEN 6
        WHEN 'Sunday   ' THEN 7
    END;

--3) Display the department and manager id wise avg commission for all employees. Round the commission up to 1 decimals.
select department_id, manager_id, round(avg(commission_pct),1) from employees
GROUP BY department_id, manager_id;
