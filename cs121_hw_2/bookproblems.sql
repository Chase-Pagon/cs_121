-- USE university;
-- USE library;

-- [Problem 1a]
-- Natural joins takes and course to get whats been taken by students and 
-- dept_name of those course then natural join with student just the ID and
-- name so then we can filter out which student names we want by asking where
-- dept_name of course = comp sci
SELECT DISTINCT name FROM takes NATURAL JOIN course NATURAL JOIN 
(SELECT ID, name FROM student) AS t WHERE dept_name = 'Comp. Sci.';

-- [Problem 1b]
-- Getting the max from each dept after grouping by apartment name in 
-- the instructor table
SELECT dept_name, MAX(salary) salary FROM instructor GROUP BY dept_name;

-- [Problem 1c]
-- Getting the min salary from the column of salary from problem 1c
SELECT MIN(salary) FROM 
(SELECT dept_name, MAX(salary) salary FROM instructor GROUP BY dept_name) as t;

-- [Problem 1d]
-- same as above but using with statement
WITH cte AS 
(SELECT dept_name, MAX(salary) salary FROM instructor GROUP BY dept_name)
 SELECT MIN(salary) FROM cte;

-- [Problem 2a]
-- Creating a new row in course with the values stated
INSERT INTO course (course_id, title, dept_name, credits) 
VALUES ('CS-001', 'Weekly Seminar', 'Comp. Sci.', 3);

-- [Problem 2b]
-- Creates a new row in section with the values stated
INSERT INTO section (course_id, sec_id, semester, year) 
VALUES ('CS-001', '1', 'Winter', 2021);

-- [Problem 2c]
-- Creates a new row in takes for every student that the dept_name = 'comp sci'
INSERT INTO takes (ID, course_id, sec_id, semester, year) 
SELECT ID, 'CS-001', '1', 'Winter', 2021 
FROM student WHERE dept_name = 'Comp. Sci.';

-- [Problem 2d]
-- Deletes a row from takes if the student name is Chavez
DELETE FROM takes WHERE (course_id = 'CS-001') AND 
(ID IN (SELECT ID FROM student WHERE name = 'Chavez'));

-- [Problem 2e]
-- No errors will occur. It will automatically delete any section offering
-- with the course_id of CS-001
DELETE FROM course WHERE (course_id = 'CS-001');

-- [Problem 2f]
-- Deletes any row from takes where the course id matches the course id 
-- where the name contains database
DELETE FROM takes WHERE course_id in 
(SELECT course_id FROM course WHERE title LIKE '%database%');

-- [Problem 3a]
-- Natural joins member and borrowed through memb_no and then joins borrowed
-- and book through isbn, thus we could get names from people who borrowed 
-- books with published mcgraw-hill
SELECT DISTINCT name FROM member NATURAL JOIN borrowed 
NATURAL JOIN book WHERE publisher = 'McGraw-Hill';

-- [Problem 3b]
-- In this we use the same statement as above but then we group by person name
-- and count the number of rows for each member that borrowed a book with the 
-- publisher mcgraw-hill and compare it to the count of the number of books 
-- that have been published by mcgraw-hill 
SELECT DISTINCT name FROM member NATURAL JOIN borrowed NATURAL JOIN book 
WHERE publisher = 'McGraw-Hill'
GROUP BY name HAVING count(*) = (SELECT count(*) 
FROM book WHERE publisher = 'McGraw-Hill');

-- [Problem 3c]
-- Same as above but instead of 
SELECT DISTINCT name FROM member NATURAL JOIN borrowed NATURAL JOIN book
GROUP BY name HAVING count(*) > 5;

-- [Problem 3d]
-- Uses a left join as some of the members have not read any books. Count by 
-- isbn because it will return 0 if the member left joins borrowed is null 
-- value. Then just avg the book count of the book_count column.
SELECT AVG(book_count) AS avg_count FROM 
(SELECT name, COUNT(isbn) AS book_count FROM member NATURAL LEFT JOIN borrowed
GROUP BY name) as t;

-- [Problem 3e]
-- Same logic at 3d but using the with statment
WITH t AS (SELECT name, COUNT(isbn) AS book_count 
FROM member NATURAL LEFT JOIN borrowed GROUP BY name)
SELECT AVG(book_count) AS avg_count FROM t;