--1. For each department, retrieve the department no, the number of employees in the department and their average
--salary.

select department_id, count(employee_id), avg(salary) from EMPLOYEES
group  by DEPARTMENT_ID;

--2. For each department that has more than five employees, retrieve the department number and the number of its
--employees who are making more than $20,000.

select DEPARTMENT_ID, count(EMPLOYEE_ID) AS EMPLOYEE_COUNT
FROM EMPLOYEES
where SALARY > 20000
group by DEPARTMENT_ID
having count(EMPLOYEE_ID) > 5;

--3. Write a Query to display the number of employees with the same job.

select job_id, count(employee_id) from employees
group by job_id;

--4. Display the manager number and the salary of the lowest paid employee of that manager. Exclude anyone whose
--manager is not known. Exclude any groups where the minimum salary is 2000. Sort the output is descending order
--of the salary. 

select manager_id, min(salary) from employees 
group by MANAGER_ID
having manager_id is not null and min(salary) <> 2000
order by min(salary) desc;
21k3445
--5. Insert a new department with the same manager as the department with the least number of employees. Assign the
--department a new unique department ID and a name of your choice.

INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID)
VALUES (
    1, 
    'hr',
    (SELECT MANAGER_ID
     FROM DEPARTMENTS
     WHERE DEPARTMENT_ID = (
         SELECT DEPARTMENT_ID
         FROM (
             SELECT DEPARTMENT_ID
             FROM EMPLOYEES
             GROUP BY DEPARTMENT_ID
             having department_id is not null
             ORDER BY COUNT(EMPLOYEE_ID)
         ) WHERE ROWNUM = 1)),
         3000
);

select * from departments; --To check if new depart inserted or not

--6. Write a Query to select Firstname and Hiredate of Employees Hired right after the joining of employee_ID no 110.

select first_name, hire_date from employees
where hire_date > (
    select Start_date from job_history
    where employee_id = 110
);

--7. Write a SQL query to select those departments where maximum salary is at least 15000.

select department_id, max(salary) from employees
group by department_id
having max(salary) >= 15000;

--8. Write a query to display the employee number, name (first name and last name) and job title for all employees
--whose salary is smaller than any salary of those employees whose job title is IT_PROG.

select 
    employee_id, 
    first_name||' '||last_name as "Name",
    job_id
from employees
where salary < any (
    select salary from employees
    where job_id = 'IT_PROG'
    );

--9. Write a query in SQL to display all the information of those employees who did not have any job in the past.

select * from employees
where employee_id not in (
    select employee_id from job_history
);

--10. Insert into employees_BKP as it should copy the record of the employee whose start date is ’13-JAN-01’ from
--job_History table.

insert into employees_BKP
select * from employees
where employee_id in (
    select j.employee_id from job_history j
    where j.START_DATE = TO_DATE('13-JAN-01', 'DD-MON-YY')
); 21k3445

--11. Update salary of employees by 20% increment having minimum salary of 6000.

UPDATE employees
SET salary = salary * 1.2
WHERE salary >= 6000; 

--12. Write a SQL query to search for employees who receive such a salary, which is the maximum salary for salaried
--employees, hired between January 1st, 2002 and December 31st, 2003. Return employee ID, first name, last name,
--salary, department name and city.

SELECT employee_id, first_name, last_name, salary,
       (SELECT department_name FROM departments WHERE department_id = e.department_id) AS department_name,
       (SELECT city FROM locations WHERE location_id = (SELECT location_id FROM departments WHERE department_id = e.department_id)) AS city
FROM employees e
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
    WHERE hire_date BETWEEN TO_DATE('01-JAN-2002', 'DD-MON-YYYY') AND TO_DATE('31-DEC-2003', 'DD-MON-YYYY')
)
AND hire_date BETWEEN TO_DATE('01-JAN-2002', 'DD-MON-YYYY') AND TO_DATE('31-DEC-2003', 'DD-MON-YYYY');

