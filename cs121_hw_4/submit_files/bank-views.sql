-- [Problem 1a]

CREATE VIEW stonewell_customers AS SELECT customer_name, account_number
FROM depositor NATURAL JOIN account
WHERE branch_name = 'Stonewell';

-- [Problem 1b]

CREATE VIEW onlyacct_customers AS 
SELECT customer_name, customer_street, customer_city
FROM customer WHERE customer_name IN (SELECT customer_name FROM depositor)
AND customer_name NOT IN (SELECT customer_name FROM borrower);

-- [Problem 1c]

CREATE VIEW branch_deposits AS SELECT branch_name, 
IFNULL(SUM(balance), 0) as account_balance, 
IFNULL(AVG(balance), NULL) as avg_balance
FROM branch NATURAL LEFT JOIN account GROUP BY branch_name;

-- SELECT test_date, holiday, is_holiday(test_date) FROM test_dates;



