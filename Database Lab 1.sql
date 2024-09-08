/*DB Lab 1 21k3445 Adnan haider*/

--LAB TASKS:
--1. Write a SQL statement to display all the information of table Employees.
--2. Write a SQL query to find min and max salary of the Job table with Job title ‘President’ from Jobs table.
--3. Write a SQL query to find those employees whose Salaries is greater than 20000 from Employees table.
--4. Write a SQL query to find the Jobs whose salary are higher than or equal to $15000 from Employees table.
--5. Write a SQL query to find the details of employees whose last name is &#39;Snares&#39;. Return employee ID, employee first name, employee last name and employee dept ID.
--6. Write a SQL query to find the details of the employees who work in the department 57. Return employee ID, employee first name, employee last name and employee dept ID.
--7. Write a query to find the PHONE_NUMBER of the DEPARTMENT_ID=80 and MANAGER_ID=100 of Employees table.
--8. write a SQL query to find the Employees with the First name “John” “NEENA” and “Lency”
--9. Write a query to find the list of cities with country ID ‘IT’ from locations table.
--10. Write a query to find the list of city except country ID ‘IN’ and ‘CH’ from locations table.
--11. Write a query to find the list of jobs whose min salary is greater than 8000 and less than 15,000 from job table.
--12. Write a query to find list of phone with DEPARTMENT_ID ‘90’ but not with job_id ‘IT_PROG’ from Employees table.
--13. Write a query to find the list of employees who are hired after '12-Dec-07' from employee table.
--14. Write a query to find the list of employees who are hired after '12-Dec-07' in Department with DEPARTMENT_ID=100 from employee table.
--15. Write a query to find the list of employees who are hired after '12-Dec-07' but not in Department with DEPARTMENT_ID=100 from employee table.
--16. Write a query to find the list of employees whose COMMISSION_PCT=0 and they do not belong to DEPARTMENT_ID 90 or 100 from Employees table
--17. Write a query to find the employees who are hired in year 2007 from Employees table.
--18. Write a query to find the list of jobs whose min salary is greater than 8000 and less than 15,000 from job table.
--19. Write a query to find employee whose ID are greater than 100 and less than 150 and their department_id is greater than 30 and less than 100 along with their F_name, Last_name &amp; Job ID.
--20. Write a query to find total salary along with salary & commission_pct Total salary formula = commission_pct, salary+(commission_pct*salary)

select * from Employees;

select min_salary, max_salary from JOBS 
where job_title = 'President';

select * from employees
where salary > 20000;

select job_id from employees 
where salary >= 15000;

select employee_id, first_name, last_name, department_id
from employees
where last_name = 'Snares';

select employee_id, first_name, last_name, department_id
from employees
where department_id = 57;

select phone_number from employees
where department_id = 80 and manager_id = 100;

select * from employees
where first_name in ('John', 'NEENA', 'Lency');

select city from locations 
where country_id = 'IT';

select city from locations 
where country_id not in ('IN', 'CH');

select * from jobs
where MIN_SALARY > 8000 and MIN_SALARY < 15000;

select phone_number from employees 
where department_id = 90 and job_id != 'IT_PROG';

select * from employees 
where hire_date > '12-Dec-2007';

select * from employees 
where hire_date > '12-Dec-2007' 
and department_id = 100;

select * from employees 
where hire_date > '12-Dec-2007'
and department_id != 100;

select * from employees
where COMMISSION_PCT is null
and DEPARTMENT_ID not in (90, 100);

select * from employees
where HIRE_DATE between '1-jan-2007' and '31-dec-2007';

select * from jobs
where MIN_SALARY > 8000 and MIN_SALARY < 15000;

select FIRST_NAME, LAST_NAME, JOB_ID from employees
where (employee_id between 101 and 149)
and (department_id between 31 and 99);

select employee_id, salary, commission_pct, salary + (COALESCE(commission_pct,0) * salary) as "Total Salary" from employees;