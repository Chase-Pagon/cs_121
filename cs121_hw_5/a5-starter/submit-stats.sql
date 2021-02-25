-- use university

-- [Problem 1]

DROP FUNCTION IF EXISTS min_submit_interval;

DELIMITER !
-- Calculates the smallest difference in submission intervals given a
-- submission id
CREATE FUNCTION min_submit_interval(subm_id INT) RETURNS INT DETERMINISTIC
BEGIN
DECLARE timestamp_curr TIMESTAMP;
DECLARE timestamp_next TIMESTAMP;
DECLARE min_difference INT DEFAULT 2147483647;
DECLARE curr_difference INT;
DECLARE done INT DEFAULT 0;

DECLARE cur CURSOR FOR
SELECT sub_date FROM fileset WHERE sub_id = subm_id;

-- When fetch is complete, handler sets flag
-- 02000 is MySQL error for "zero rows fetched"
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
SET done = 1;

OPEN cur;
FETCH cur INTO timestamp_curr;
WHILE NOT done DO
FETCH cur INTO timestamp_next;
IF NOT done THEN
SET curr_difference = 
UNIX_TIMESTAMP(timestamp_next) - UNIX_TIMESTAMP(timestamp_curr);
IF curr_difference < min_difference THEN SET min_difference = curr_difference;
END IF;
SET timestamp_curr = timestamp_next;
END IF;
END WHILE;

-- It was never updated, then there must be no max difference
IF min_difference = 2147483647 THEN RETURN NULL;
END IF;
RETURN min_difference;
END !

DELIMITER ;
-- [Problem 2]

DROP FUNCTION IF EXISTS max_submit_interval;

DELIMITER !
-- Calculates the smallest difference in submission intervals given a
-- submission id
CREATE FUNCTION max_submit_interval(subm_id INT) RETURNS INT DETERMINISTIC
BEGIN
DECLARE timestamp_curr TIMESTAMP;
DECLARE timestamp_next TIMESTAMP;
DECLARE max_difference INT DEFAULT -1;
DECLARE curr_difference INT;
DECLARE done INT DEFAULT 0;

DECLARE cur CURSOR FOR
SELECT sub_date FROM fileset WHERE sub_id = subm_id;

-- When fetch is complete, handler sets flag
-- 02000 is MySQL error for "zero rows fetched"
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
SET done = 1;

OPEN cur;
FETCH cur INTO timestamp_curr;
WHILE NOT done DO
FETCH cur INTO timestamp_next;
IF NOT done THEN
SET curr_difference = 
UNIX_TIMESTAMP(timestamp_next) - UNIX_TIMESTAMP(timestamp_curr);
IF curr_difference > max_difference THEN SET max_difference = curr_difference;
END IF;
SET timestamp_curr = timestamp_next;
END IF;
END WHILE;

-- It was never updated, then there must be no max difference
IF max_difference = -1 THEN RETURN NULL;
END IF;
RETURN max_difference;
END !

DELIMITER ;

-- [Problem 3]

DROP FUNCTION IF EXISTS avg_submit_interval;

DELIMITER !

-- Calculates the avg submit interval between submissions
CREATE FUNCTION avg_submit_interval(subm_id INT) RETURNS DOUBLE DETERMINISTIC
BEGIN
DECLARE max_time TIMESTAMP;
DECLARE min_time TIMESTAMP;
DECLARE total_sub INT;
SELECT MAX(sub_date), MIN(sub_date), COUNT(*) FROM fileset 
WHERE sub_id = subm_id INTO max_time, min_time, total_sub;
RETURN ((UNIX_TIMESTAMP(max_time) - UNIX_TIMESTAMP(min_time))
 / (total_sub - 1));
END !

DELIMITER ;
-- [Problem 4]

-- Index on sub_id and sub_date so that we can access this information faster
CREATE INDEX idx_sub_id ON fileset (sub_id, sub_date);

-- Testing
-- SELECT sub_id, min_submit_interval(sub_id) AS min_interval, 
-- max_submit_interval(sub_id) AS max_interval, avg_submit_interval(sub_id) 
-- AS avg_interval FROM (SELECT sub_id FROM fileset
-- GROUP BY sub_id HAVING COUNT(*) > 1) AS multi_subs
-- ORDER BY min_interval, max_interval;


