/* 21k3445 Adnan haider 
Lab 1 additional Tasks */

--Question 1:
--How can you retrieve employees whose salary is higher than all employees in department 60?

--Using Subquery
SELECT *
FROM employees
WHERE salary > 
(
    select MAX(salary) from employees
    where department_id = 60
);


--Question 2:
--Find all employees who are in department 50 and have a salary greater than 8000?
select * from employees 
where department_id = 50 and salary > 8000;

--Question 3:
--Select employees whose salary is greater than any salary in department 50?
select * from employees 
where salary > ANY
(
    select salary from employees
    where department_id = 50
);

--Question 4:
--Find all employees with a salary between 40,000 and 60,000?
select * from employees 
where salary between 40000 and 60000;

--Question 5:
--How can you retrieve employees who belong to the HR department?

--using subquery
select * from employees
where department_id = 
(
    select department_id from DEPARTMENTS
    where department_name = 'HR'
);

--Question 6:
--How can you get a list of employees who are in departments 90, 60, or 30?

--Using IN operator
select * from employees 
where department_id IN (90, 60, 30);

--Question 7:
--Select employees whose last name starts with 'Ja'?
select * from employees
where last_name like 'Ja%';

--Question 8:
--Find employees who are not in departments 100, 50, or 80?
select * from employees 
where department_id NOT IN (90, 60, 30);

--Question 9:
--How can you retrieve employees who are either in department 30 or have a salary greater than 70,000?

--using OR operator
select * from employees
where department_id = 30 OR salary > 70000;

--Question 10:
--How can you find employees who do not have a manager assigned to them?

--using NULL keyword
select * from employees
where MANAGER_ID is null;

--Question 11:
--How can you retrieve all unique salary values from the Employees table?

--using distinct keyword
select DISTINCT salary from employees;