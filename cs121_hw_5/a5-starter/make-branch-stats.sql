-- use banking

-- [Problem 1]

-- Creates an index with branch_name and balance because later we will be
-- selceting branch_name and balance and grouping on branch_name

CREATE INDEX idx_branch_balance ON account (branch_name, balance);

-- [Problem 2]

DROP TABLE IF EXISTS mv_branch_account_stats;

-- Creates a table which represents the materialized results of branch account
-- stats. All of the column names are pretty self explanatory.
CREATE TABLE mv_branch_account_stats (
branch_name VARCHAR(15) PRIMARY KEY,
num_accounts INT NOT NULL,
total_deposits NUMERIC(12, 2) NOT NULL,
min_balance NUMERIC(12, 2) NOT NULL,
max_balance NUMERIC(12, 2) NOT NULL
);

-- [Problem 3]

-- Populates the mv_branch_account_stats table with account table info
INSERT INTO mv_branch_account_stats SELECT branch_name, COUNT(*),
SUM(balance), MIN(balance), MAX(balance)
FROM account GROUP BY branch_name;

-- [Problem 4]

-- Creates view to represent mv_branch_account_stats
DROP VIEW IF EXISTS branch_account_stats;

CREATE VIEW branch_account_stats AS SELECT branch_name, num_accounts,
total_deposits, (total_deposits / num_accounts) AS avg_balance,
min_balance, max_balance
FROM mv_branch_account_stats;

-- [Problem 5]

DROP PROCEDURE IF EXISTS tr_insert_helper;
DROP TRIGGER IF EXISTS tr_insert;

DELIMITER !

-- Updates the mv_branch_account_stats table after a row is inserted into
-- the account table

CREATE PROCEDURE tr_insert_helper
(new_branch_name VARCHAR(15), new_balance NUMERIC(12, 2))
BEGIN
DECLARE new_min_balance NUMERIC(12, 2);
DECLARE new_max_balance NUMERIC(12, 2);

-- Insert new row into mv_branch_account_stats if the branch_name is not there
-- already
IF new_branch_name NOT IN (SELECT branch_name FROM mv_branch_account_stats)
THEN INSERT INTO mv_branch_account_stats VALUES (new_branch_name, 1,
 new_balance, new_balance, new_balance);
ELSE

-- Otherwise calculate new values and update the 
-- row in mv_branch_account_stats
SELECT MIN(balance), MAX(balance)
FROM account WHERE branch_name = new_branch_name GROUP BY branch_name
INTO new_min_balance, new_max_balance;

UPDATE mv_branch_account_stats SET num_accounts = num_accounts + 1,
total_deposits = total_deposits + new_balance,
min_balance = new_min_balance, max_balance = new_max_balance
WHERE branch_name = new_branch_name;
END IF;
END !

CREATE TRIGGER tr_insert AFTER INSERT ON account FOR EACH ROW
BEGIN
CALL tr_insert_helper(NEW.branch_name, NEW.balance);
END !

DELIMITER ;

-- TEST
-- INSERT INTO account VALUES ('A-961', 'Belldale', 20);

-- [Problem 6]

DROP PROCEDURE IF EXISTS tr_delete_helper;
DROP TRIGGER IF EXISTS tr_delete;

DELIMITER !

-- Updates the mv_branch_account_stats table after a row is deleted from
-- the account table

CREATE PROCEDURE tr_delete_helper 
(old_branch_name VARCHAR(15), old_balance NUMERIC(12, 2))
BEGIN
DECLARE new_min_balance NUMERIC(12, 2);
DECLARE new_max_balance NUMERIC(12, 2);

-- Delete if there is only one account
DELETE FROM mv_branch_account_stats 
WHERE branch_name = old_branch_name AND num_accounts = 1;

IF old_branch_name IN (SELECT branch_name FROM mv_branch_account_stats)
THEN
SELECT MIN(balance), MAX(balance)
FROM account WHERE branch_name = old_branch_name GROUP BY branch_name
INTO new_min_balance, new_max_balance;

-- After calculating the new min and max then update the rest of the row
UPDATE mv_branch_account_stats SET num_accounts = num_accounts - 1,
total_deposits = total_deposits - old_balance,
min_balance = new_min_balance, max_balance = new_max_balance
WHERE branch_name = old_branch_name;
END IF;
END !

CREATE TRIGGER tr_delete AFTER DELETE ON account FOR EACH ROW
BEGIN
CALL tr_delete_helper(OLD.branch_name, OLD.balance);
END !

DELIMITER ;

-- TEST
-- DELETE FROM account WHERE account_number = 'A-961';

-- [Problem 7]

DROP TRIGGER IF EXISTS tr_update;

DELIMITER !

-- Updating is the same thing as deleting the old information and entering
-- in the new information

CREATE TRIGGER tr_update AFTER UPDATE ON account FOR EACH ROW
BEGIN
CALL tr_delete_helper(OLD.branch_name, OLD.balance);
CALL tr_insert_helper(NEW.branch_name, NEW.balance);
END !

-- TEST
-- UPDATE account SET balance = 670000.00 WHERE account_number = 'A-335';

DELIMITER ;
