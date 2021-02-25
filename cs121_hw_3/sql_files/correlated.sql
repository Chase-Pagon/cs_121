-- The query calculates the number of loans each customer has
-- and puts it into descending order by number of loans
-- [Problem a]
SELECT customer_name, COUNT(loan_number) as num_loans
FROM customer NATURAL LEFT JOIN borrower
GROUP BY customer_name ORDER BY num_loans DESC;

-- The query gets the branch_name of branchs where the assests of the branch
-- less than the total of all the loans at the branch
-- [Problem b]
SELECT branch_name FROM (SELECT branch_name, assets, SUM(amount) as loan_sum
FROM branch NATURAL LEFT JOIN loan
GROUP BY branch_name, assets) 
AS branch_assets_loans 
WHERE assets < loan_sum;

-- Using correlated subqueries in the SELECT clause, write a SQL query that
-- computes the number of accounts and the number of loans at each branch. 
-- The result schema should be (branch_name, num_accounts, num_loans). Order
-- the results by increasing branch name.

-- [Problem c]
SELECT branch_name,
(SELECT COUNT(*) FROM account a WHERE a.branch_name = b.branch_name)
 AS num_accounts,
(SELECT COUNT(*) FROM loan l WHERE l.branch_name = b.branch_name)
 AS num_loans
FROM branch b GROUP BY branch_name;

-- Decorrelated version of the previous query
-- [Problem d]
SELECT branch_name, COUNT(DISTINCT account_number) as num_accounts,
COUNT(DISTINCT loan_number) as num_loans 
FROM branch NATURAL LEFT JOIN account NATURAL LEFT JOIN loan
GROUP BY branch_name ORDER BY branch_name;

