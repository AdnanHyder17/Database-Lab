--21k3445 Adnan 

--DML Trigger Task:
--
--• Create a trigger that automatically inserts a record into the job_history table when an
--employees job changes in the employees table.

CREATE OR REPLACE TRIGGER trg_job_history
AFTER UPDATE OF job_id ON employees
FOR EACH ROW
ENABLE
BEGIN
    INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id) 
    VALUES (:OLD.employee_id, :OLD.hire_date, SYSDATE, :OLD.job_id, :OLD.department_id);
END;
/

--• Create a trigger to log every change in an employee’s salary. Create a table
--salary_change_log table, capturing the old and new salary values.

CREATE TABLE salary_change_log (
    employee_id NUMBER,
    old_salary NUMBER,
    new_salary NUMBER,
    change_date DATE
);

CREATE OR REPLACE TRIGGER trg_salary_change
AFTER UPDATE OF salary ON employees
FOR EACH ROW
ENABLE
BEGIN
    INSERT INTO salary_change_log (employee_id, old_salary, new_salary, change_date) 
    VALUES (:OLD.employee_id, :OLD.salary, :NEW.salary, SYSDATE);
END;
/

--• Create a trigger that prevents adding employees to a department if the department
--headcount exceeds 50 employees.

CREATE OR REPLACE TRIGGER trg_limit_department_size
BEFORE INSERT ON employees
FOR EACH ROW
ENABLE
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM employees
    WHERE department_id = :NEW.department_id;

    IF v_count >= 50 THEN
        DBMS_OUTPUT.PUT_LINE('Department headcount exceeds 50 employees.');
    END IF;
END;
/

--• Create a trigger that prevents changing the job title of employees with more than 10 years
--of experience. 

CREATE OR REPLACE TRIGGER trg_prevent_job_change
BEFORE UPDATE OF job_id ON employees
FOR EACH ROW
DECLARE
    v_experience NUMBER;
BEGIN
    SELECT MONTHS_BETWEEN(SYSDATE, hire_date) / 12
    INTO v_experience
    FROM employees
    WHERE employee_id = :NEW.employee_id;

    IF v_experience > 10 THEN
        DBMS_OUTPUT.PUT_LINE('Cannot change job title of employees with more than 10 years of experience.');
    END IF;
END;
/


--213445 Adnan

--DDL Trigger Tasks:

--• Create a DDL trigger that logs every column modification (ADD, DROP, MODIFY)
--made to the employees or departments tables.

CREATE TABLE column_modification_log (
    table_name VARCHAR2(30),
    operation VARCHAR2(30),
    modified_by VARCHAR2(30),
    modification_time DATE
);

CREATE OR REPLACE TRIGGER trg_column_modification
AFTER ALTER ON SCHEMA
DECLARE
    v_operation VARCHAR2(30);
    v_table_name VARCHAR2(30);
BEGIN
    v_operation := ORA_SYSEVENT;
    v_table_name := ORA_DICT_OBJ_NAME;

    IF v_table_name IN ('EMPLOYEES', 'DEPARTMENTS') THEN
        INSERT INTO column_modification_log (
            table_name, operation, modified_by, modification_time
        ) VALUES (
            v_table_name, v_operation, SYS_CONTEXT('USERENV', 'SESSION_USER'), SYSDATE
        );
    END IF;
END;
/


--• Create a DDL trigger that prevents dropping any table on weekends (Saturday and
--Sunday). Log any drop attempts into a drop_attempt_log table.

CREATE TABLE drop_attempt_log (
    table_name VARCHAR2(50),
    attempt_time DATE,
    user_name VARCHAR2(50)
);

CREATE OR REPLACE TRIGGER trg_prevent_drop_on_weekend
BEFORE DROP ON SCHEMA
DECLARE
    v_day_of_week VARCHAR2(10);
BEGIN
    v_day_of_week := TO_CHAR(SYSDATE, 'DAY');

    IF v_day_of_week IN ('SATURDAY', 'SUNDAY') THEN
        INSERT INTO drop_attempt_log (table_name, attempt_time, user_name) 
        VALUES (ORA_DICT_OBJ_NAME, SYSDATE, USER);
        
        DBMS_OUTPUT.PUT_LINE('Dropping tables on weekends is not allowed.');
    END IF;
END;
/


--• Create a DDL trigger that logs every new view creation into a view_creation_log table,
--capturing the view name, creator, and creation time.

CREATE TABLE view_creation_log (
    view_name VARCHAR2(50),
    creator VARCHAR2(50),
    creation_time DATE
);

CREATE OR REPLACE TRIGGER trg_log_view_creation
AFTER CREATE ON SCHEMA
DECLARE
BEGIN
    IF ORA_DICT_OBJ_TYPE = 'VIEW' THEN
        INSERT INTO view_creation_log 
        (view_name, creator, creation_time) 
        VALUES (ORA_DICT_OBJ_NAME, USER, SYSDATE);
        
        DBMS_OUTPUT.PUT_LINE('New view created: ' || ORA_DICT_OBJ_NAME);
    END IF;
END;
/


--System/Database Trigger Task:

--• Create a system trigger that logs whenever the database shuts down into a
--system_shutdown_log table. Record the shutdown time and the user initiating it.

CREATE TABLE system_shutdown_log (
    shutdown_time DATE,
    user_name VARCHAR2(50)
);

--GRANT ADMINISTER DATABASE TRIGGER TO user; Run by Admin(Homeuser)
--select user from dual; to check user name

CREATE OR REPLACE TRIGGER trg_log_shutdown
BEFORE SHUTDOWN ON DATABASE
BEGIN
    INSERT INTO system_shutdown_log (shutdown_time, user_name)
    VALUES (SYSDATE, USER);
END;
/

--• Create a system trigger that logs user login attempts and records the username and login
--time in a login_audit table.

CREATE TABLE login_audit (
    user_name VARCHAR2(50),
    login_time DATE
);

CREATE OR REPLACE TRIGGER trg_log_login
AFTER LOGON ON DATABASE
BEGIN
    INSERT INTO login_audit (user_name, login_time)
    VALUES (USER, SYSDATE);
END;
/

--• Create a trigger that logs failed login attempts and stores the username, time, and error
--message into a failed_login_attempts table.

CREATE TABLE failed_login_attempts (
    user_name VARCHAR2(50),
    attempt_time DATE,
    error_message VARCHAR2(2000)
);

CREATE OR REPLACE TRIGGER trg_log_failed_login
AFTER SERVERERROR ON DATABASE
DECLARE
    v_error_message VARCHAR2(2000);
BEGIN
    IF (IS_SERVERERROR(1017)) THEN -- ORA-01017: invalid username/password; logon denied
        v_error_message := DBMS_UTILITY.FORMAT_ERROR_STACK;
        
        INSERT INTO failed_login_attempts (user_name, attempt_time, error_message)
        VALUES (USER, SYSDATE, v_error_message);
        
    END IF;
END;
/
--21k3455 Adnan
--Instead of Trigger Task:

--• Create a view that joins employees and departments. Write an INSTEAD OF UPDATE
--trigger to update employee contact details in the employees table through the view.

CREATE OR REPLACE VIEW emp_dept_view AS
SELECT e.employee_id, e.first_name, e.last_name, e.phone_number, e.email, e.department_id, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

CREATE OR REPLACE TRIGGER trg_instead_of_update_contact
INSTEAD OF UPDATE ON emp_dept_view
FOR EACH ROW
ENABLE
BEGIN
    UPDATE employees
    SET phone_number = :NEW.phone_number, email = :NEW.email
    WHERE employee_id = :OLD.employee_id;
END;
/

--• Create a view that joins employees and departments. Write an INSTEAD OF INSERT
--trigger to insert data into both employees and departments through the view.

CREATE OR REPLACE TRIGGER trg_instead_of_insert_emp_dept
INSTEAD OF INSERT ON emp_dept_view
FOR EACH ROW
DECLARE
    v_dept_count NUMBER;
BEGIN
    -- Check if the department already exists
    SELECT COUNT(*)
    INTO v_dept_count
    FROM departments
    WHERE department_id = :NEW.department_id;
    
    -- Insert into departments table if it doesn't exist
    IF v_dept_count = 0 THEN
        INSERT INTO departments (department_id, department_name)
        VALUES (:NEW.department_id, :NEW.department_name);
    END IF;
    
    -- Insert into employees table
    INSERT INTO employees (employee_id, first_name, last_name, phone_number, email, department_id)
    VALUES (:NEW.employee_id, :NEW.first_name, :NEW.last_name, :NEW.phone_number, :NEW.email, :NEW.department_id);
END;
/

--• Create a view that joins departments and locations. Write an INSTEAD OF INSERT
--trigger that prevents inserting duplicate department names.

CREATE OR REPLACE VIEW dept_loc_view AS
SELECT d.department_id, d.department_name, l.location_id, l.city
FROM departments d
JOIN locations l ON d.location_id = l.location_id;

CREATE OR REPLACE TRIGGER trg_instead_of_insert_dept_loc
INSTEAD OF INSERT ON dept_loc_view
FOR EACH ROW
DECLARE
    v_dept_count NUMBER;
BEGIN
    -- Check for duplicate department names
    SELECT COUNT(*) INTO v_dept_count
    FROM departments
    WHERE department_name = :NEW.department_name;
    
    IF v_dept_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Duplicate department name insertion prevented.');
    ELSE
        -- Insert into departments table
        INSERT INTO departments (department_id, department_name, location_id)
        VALUES (:NEW.department_id, :NEW.department_name, :NEW.location_id);
    END IF;
END;
/
