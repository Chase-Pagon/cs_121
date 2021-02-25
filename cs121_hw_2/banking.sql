-- USE banking;

-- [Problem 0]
-- 1. Numeric is an Exact Numeric Data Type whereas float is an Appoximate
-- Numeric Data Type. Basically it is not as precise as a numeric so a float
-- overtime could lead to rounding errors which especially in dealing with 
-- large amounts of money is not something we want to be happening.
-- 2. We would want the balance variable to be represented by a different type
-- than a VARCHAR. A numeric for this datatype would be more accurate and since
-- it is a bank account balance we would want it to be very precise.

-- [Problem 1a]
-- Selects loan_number and amount in which loan is between 1000 and 2000
SELECT loan_number, amount FROM loan WHERE 1000 < amount AND amount < 2000;

-- [Problem 1b]
-- Natural join loan and borrower to find customer_name = 'Smith' then order
-- by loan_number
SELECT loan_number, amount FROM loan NATURAL JOIN borrower 
WHERE customer_name = 'Smith' ORDER BY loan_number;

-- [Problem 1c]
-- Natural join account and branch to get access to account number is equal
-- to 'A-446'
SELECT branch_city FROM account NATURAL JOIN branch 
WHERE account_number = 'A-446';

-- [Problem 1d]
-- Get J names from natural join account to depositor to customer and 
-- order by customer name
SELECT customer_name, account_number, branch_name, balance 
FROM account NATURAL JOIN depositor NATURAL JOIN customer 
WHERE customer_name LIKE 'j%' ORDER BY customer_name;

-- [Problem 1e]
-- Same as before but instead counting if account_number > 5 
SELECT customer_name FROM account NATURAL JOIN depositor NATURAL JOIN customer
GROUP BY customer_name HAVING count(account_number) > 5;

-- [Problem 2a]
-- Gets customer_cities without branch in their city and orders by 
-- customer city
SELECT DISTINCT customer_city FROM customer WHERE customer_city 
NOT IN (SELECT branch_city FROM branch) ORDER BY customer_city;

-- [Problem 2b]
-- Just checking if the customer name is not in the depositor 
-- and borrower relations
SELECT DISTINCT customer_name FROM customer WHERE customer_name 
NOT IN (SELECT customer_name FROM depositor) AND customer_name 
NOT IN (SELECT customer_name FROM borrower);

-- [Problem 2c]
-- Updates balance to +75 where for each branch_name that has the 
-- branch_city of horseneck
SET SQL_SAFE_UPDATES = 0;
UPDATE account SET balance = balance + 75 WHERE branch_name 
IN (SELECT branch_name FROM branch WHERE branch_city = 'Horseneck');
SET SQL_SAFE_UPDATES = 1;

-- [Problem 2d]
-- Same as 2c just different where statement updates
SET SQL_SAFE_UPDATES = 0;
UPDATE account account, branch branch SET balance = balance + 75 
WHERE account.branch_name = branch.branch_name 
AND branch.branch_city = 'Horseneck';
SET SQL_SAFE_UPDATES = 1;

-- [Problem 2e]
-- Natural join account with itself with the max values grouped by branch name
-- to find the accounts with the max balance at each branch
SELECT account_number, branch_name, balance FROM account NATURAL JOIN 
(SELECT branch_name, MAX(balance) AS balance FROM account GROUP BY branch_name)
as t;

-- [Problem 2f]
-- Same logic just using a where and in statement on the resulting table 
-- instead of a natural joins
SELECT account_number, branch_name, balance FROM account 
WHERE (branch_name, balance) IN (SELECT branch_name, MAX(balance) 
AS balance FROM account GROUP BY branch_name);

-- [Problem 3]
-- Create a new column as rank that is the count of branches that have a 
-- higher assest value than the branch. Use rename to compare all the branches
-- to eachother to find the number that have higher asset values than itself.
-- Then groups by branch_name, assets and orders by the new 'count' of branches
-- it has above it in asset value.
SELECT branch_name, assets, COUNT(*) AS 'rank'
FROM (SELECT b1.branch_name, b1.assets FROM branch b1, branch b2 
WHERE b1.assets < b2.assets OR b1.branch_name = b2.branch_name) AS t
GROUP BY branch_name, assets ORDER BY COUNT(*), branch_name;
 

