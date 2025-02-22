--21k3445 DB Lab 5

--1. Write a query to list the name, job title, department name, and salary of the employees in ascending order of
--their department.

select e.first_name, j.job_title, d.department_name, e.salary 
from employees e join departments d on e.department_id = d.department_id
join jobs j on e.job_id = j.job_id
order by d.department_name;

--2. Write a query to list the departments where at least two employees are working.

select count(e.employee_id), d.department_name from employees e join departments d 
on e.department_id = d.department_id
group by d.department_name
HAVING COUNT(e.employee_id) >= 2;

--3. Fetch all records where the employee's salary is less than the lowest salary in the company.

select * from employees join jobs
on employees.job_id = jobs.job_id
where employees.salary < jobs.min_salary;

--4. Write a query to list the name, job title, annual salary, department name, and city of employees who earn
--60000 or more annually and are not working as ANALYST.

select e.first_name, j.job_title, 12*(e.salary) as "Annual Salary",
d.department_name, l.city from employees e 
join departments d on e.department_id = d.department_id
join jobs j on e.job_id = j.job_id
join locations l on d.location_id = l.location_id
where 12*(e.salary) > 60000 and j.job_title != 'ANALYST'; 

--5. Write a query to print details of the employees who are also Managers.

select e1.first_name, e2.first_name from employees e1 
join employees e2 on e1.manager_id = e2.employee_id;

--6. List department number and department name for all departments that have no employees.

select d.department_id, d.department_name from employees e
right outer join departments d on e.department_id = d.department_id
group by d.department_id, d.department_name
having count(e.employee_id) = 0;

--7. Display employee name, salary, and department name where all employees match their department, including
--employees with no assigned department.

select e.first_name, e.salary, d.department_name from employees e 
left outer join departments d on e.department_id = d.department_id;

--8. Display the name, job title, department name, and city of employees who are working in departments located
--in cities without a state province.

select e.first_name, j.job_title, d.department_name, l.city, l.STATE_PROVINCE from employees e 
join departments d on e.department_id = d.department_id
join jobs j on e.job_id = j.job_id
join locations l on d.location_id = l.location_id
where l.state_province is null;

--9. Write an SQL query to show records from one table that do not exist in another table.
delete from employee_replica where manager_id = 100; --making employee_replica differnt than employees table

SELECT employee_id, first_name, manager_id
FROM employees
MINUS --will show the different records within both tables
SELECT employee_id, first_name, manager_id
FROM employee_replica;

--10. Display all employees who belong to the US but not to the state of Washington.

select * from employees e 
join departments d on e.department_id = d.department_id
join locations l on d.location_id = l.location_id
where l.COUNTRY_ID = 'US' and l.state_province != 'Washington';

--11. Write a query to list the name, job title, department name, and location of employees who have a salary higher
--than the average salary in their department.

SELECT e.first_name, j.job_title, d.department_name, l.city
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN jobs j ON e.job_id = j.job_id
JOIN locations l ON d.location_id = l.location_id
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);

--12. Write a query to list employees who have changed their job title at least once in their job history.

SELECT e.employee_id, e.first_name
FROM employees e
JOIN job_history jh ON e.employee_id = jh.employee_id
GROUP BY e.employee_id, e.first_name
HAVING COUNT(jh.job_id) > 1;

--13. List employees who work in the same department as their managers.

select * from employees e1 
join employees e2 on e1.manager_id = e2.employee_id
where e1.department_id = e2.department_id;

--14. Write a query to list the name, department name, and location of employees who work in the same country as
--their department location.

SELECT e.first_name, e.last_name, d.department_name, l.city, l.country_id FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id; 

--15. Write a query to find employees who work in departments with more than 5 employees.

SELECT e.employee_id, e.first_name, e.last_name
FROM employees e
WHERE department_id IN (
        SELECT department_id 
        FROM employees 
        GROUP BY department_id 
        HAVING COUNT(employee_id) > 5
    );

--16. Display a list of employees along with their managers&#39; names.

SELECT 
    employees.employee_id,
    employees.first_name,
    employees.last_name,
    e2.first_name,
    e2.last_name
FROM employees
LEFT JOIN employees e2 ON employees.manager_id = e2.employee_id;

--17. Write a query to list the employee names and their department names where the department is located in a
--different country than the employee’s residence.

SELECT e.first_name, e.last_name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
WHERE l.country_id <> e.country_id; -- Assuming employees have country_id


--18. Write a query to find employees who earn more than their department&#39;s average salary but less than the
--highest salary in the company.

SELECT e.first_name, e.last_name, e.salary, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > (
        SELECT AVG(e2.salary)
        FROM employees e2
        WHERE e2.department_id = e.department_id
    )
AND e.salary < (
        SELECT MAX(e3.salary)
        FROM employees e3
    );


--19. Display a list of all employees who have worked in multiple departments, showing their job history and
--department names.

select * from employees e
join job_history jh on e.employee_id = jh.employee_id
where e.employee_id in (
    select employee_id from JOB_HISTORY
    GROUP BY employee_id
    HAVING COUNT(DISTINCT department_id) > 1
);

--20. Write a query to find employees who have worked in more than one region throughout their career.

SELECT e.employee_id, e.first_name, e.last_name
FROM employees e
JOIN job_history jh ON e.employee_id = jh.employee_id
JOIN departments d ON jh.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
JOIN countries c ON l.country_id = c.country_id
GROUP BY e.employee_id, e.first_name, e.last_name
HAVING COUNT(DISTINCT c.region_id) > 1;

--21. List all employees and the region they are working in.

SELECT e.first_name, e.last_name, c.region_id
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
JOIN countries c ON l.country_id = c.country_id;

--22. Find employees who have the same last name but work in different departments.

SELECT e1.employee_id, 
        e1.first_name, 
        e1.last_name, 
        e1.department_id,
        e2.employee_id AS other_employee_id, 
        e2.first_name AS other_first_name, 
        e2.department_id AS other_department_id
FROM employees e1
JOIN employees e2 ON e1.last_name = e2.last_name AND e1.employee_id <> e2.employee_id
WHERE e1.department_id <> e2.department_id;

--23. List employees who have changed job titles more than twice.

SELECT employee_id, COUNT(DISTINCT job_id) as job_changes
FROM job_history
GROUP BY employee_id
HAVING COUNT(DISTINCT job_id) > 2;

--24. Show job titles that are not currently assigned to any employee.

SELECT j.job_title FROM jobs j
LEFT JOIN employees e ON j.job_id = e.job_id
WHERE e.job_id IS NULL;

--25. Find the top 3 employees with the highest salaries in each department.

SELECT department_id, employee_id, salary
FROM (
    SELECT department_id, employee_id, salary,
           ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) as rn
    FROM employees
) 
WHERE rn <= 3;
