-- Adnan Haider 21k3445 DB lab 3

--1.

--Students Table

--student_id An alpha numeric value (AJ123), maximum length should be 7, not null, is a primary key.
--first_name An alphabetic value, not null, maximum length should be 10.
--last_name An alphabetic value, not null, maximum length should be 12.
--phone_number Int data type, not null, unique.

--Classes Table

--class_id An alpha numeric value, not null, is a primary key, maximum length should be 6.
--class_name Is an alphabetic value, maximum length should be 25, not null. 
--classroom_code Is an alpha numeric value, not null, put a check constraint that the length of this value should be greater than 7 and less than or equal to 10. 

CREATE TABLE Students (
    student_id VARCHAR2(7) NOT NULL PRIMARY KEY,
    first_name VARCHAR2(10) NOT NULL,
    last_name VARCHAR2(12) NOT NULL,
    phone_number NUMBER NOT NULL UNIQUE
);

CREATE TABLE Classes (
    class_id VARCHAR2(6) NOT NULL PRIMARY KEY,
    class_name VARCHAR2(25) NOT NULL,
    classroom_code VARCHAR2(10) NOT NULL CHECK (LENGTH(classroom_code) > 7)
);

--2. Change the data type of phone_number column in Students table from int to varchar, such that maximum length should be no more than 13. (Using MODIFY)
ALTER TABLE Students MODIFY phone_number VARCHAR2(13);


--3. Write a SQL statement to add class_id column in Students table as foreign key referencing to the primary key class_id of Class table.
ALTER TABLE Students ADD class_id VARCHAR2(6);
ALTER TABLE Students ADD CONSTRAINT fk_class_id FOREIGN KEY (class_id) REFERENCES Classes(class_id);

--4. Populate the Class table by inserting at least two records, having all the attributes and the class_id should automatically update in Studnets table.
INSERT INTO Classes (class_id, class_name, classroom_code)
VALUES ('C12345', 'Mathematics', 'ABC12345');

INSERT INTO Classes (class_id, class_name, classroom_code)
VALUES ('C54321', 'Physics', 'DEF12345');

--5. Add a new column email in Students table (alphanumeric, maximum length 25, not null). 
ALTER TABLE Students ADD email VARCHAR2(25) NOT NULL;

--6. Populate the Students table adding at least three records.
INSERT INTO Students (student_id, first_name, last_name, phone_number, class_id, email)
VALUES ('AJ123', 'John', 'Doe', '1234567890', 'C12345', 'john@example.com');

INSERT INTO Students (student_id, first_name, last_name, phone_number, class_id, email)
VALUES ('AJ124', 'Jane', 'Smith', '0987654321', 'C54321', 'jane@example.com');
       
INSERT INTO Students (student_id, first_name, last_name, phone_number, class_id, email)
VALUES ('AJ125', 'Tom', 'Brown', '1122334455', 'C12345', 'tom@example.com');

--7. Update the class_id for an existing student in the Students table to assign them to a different class.
UPDATE Students SET class_id = 'C54321' WHERE student_id = 'AJ123';

--8. Delete a class from the Classes table and observe what happens to the associated students in the Students table. Explain the outcome.
DELETE FROM Classes WHERE class_id = 'C12345'; --outcome: Failed because C12345 is already assigned so we first we need to remove the link

--9. Create a new table Enrollments to capture the enrollment of students in classes. The table should include student_id and class_id as foreign keys and primary keys.
CREATE TABLE Enrollments (
    student_id VARCHAR2(7),
    class_id VARCHAR2(6),
    PRIMARY KEY (student_id, class_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (class_id) REFERENCES Classes(class_id)
);

--10. Insert multiple rows (atleast 2) into the Enrollments table with different combinations of student_id and class_id.
INSERT ALL
    INTO Enrollments (student_id, class_id) VALUES ('AJ123', 'C54321')
    INTO Enrollments (student_id, class_id) VALUES ('AJ124', 'C54321')
SELECT * FROM dual;

--11. Change the table name from Enrollments to Registrations.
ALTER TABLE Enrollments RENAME TO Registrations;

--12. Change the column name in table Students from phone_number to cell_phone_number.
ALTER TABLE Students RENAME COLUMN phone_number TO cell_phone_number;

--13. Drop the column email from Students table.
ALTER TABLE Students DROP COLUMN email;

--14. Write a SQL statement to select all students and their enrolled classes using the Enrollments table.
SELECT s.student_id, s.first_name, s.last_name, r.class_id
FROM Students s
JOIN Registrations r ON s.student_id = r.student_id;

--15.Delete a record from Student table using a condition on student_id, write the id which you had populated the table with.
DELETE FROM Students WHERE student_id = 'AJ125';

--16. Update the column values of a certain student based on student_id, change their cell_phone_number.
UPDATE Students SET cell_phone_number = '9998887777' WHERE student_id = 'AJ123';

--17. Create replica of employee table.//
CREATE TABLE employee_replica AS SELECT * FROM employees;

--18. Write a SQL statement to add employee_id column in job_history table as a foreign key referencing to the primary key employee_id of employees table.
ALTER TABLE job_history ADD CONSTRAINT fk_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id);

--19. Write an SQL query where you change the class name based on the following conditions: class_id equals to some class id that you inserted previously.
--class_name should have certain pattern, (should be matched using “_” wildcard, for example, I added class_name A340, so my condition will be, class_name LIKE ‘A_40’) 

UPDATE Classes SET class_name = 'Advanced Mathematics' 
WHERE class_id = 'C12345' AND class_name LIKE 'A_40';

--20. Drop the table Registrations.
DROP TABLE Registrations;
