-- [Problem 1a]

DELIMITER !
-- Given a date value, returns 1 if it is a weekend,
-- or 0 if it is a weekday.
CREATE FUNCTION is_weekend(d DATE) RETURNS TINYINT DETERMINISTIC
BEGIN
 DECLARE weekend_int TINYINT;
 SELECT WEEKDAY(d) INTO weekend_int;
 IF weekend_int > 4 THEN RETURN 1;
 ELSE RETURN 0;
 END IF;
END !
-- Back to the standard SQL delimiter
DELIMITER ;

-- SELECT test_date, weekend, is_weekend(test_date) FROM test_dates;

-- [Problem 1b]

DELIMITER !
-- Given a date value, returns the holiday,
-- or null if no holiday.
CREATE FUNCTION is_holiday(d DATE) RETURNS VARCHAR(30) DETERMINISTIC
BEGIN
 DECLARE day_of_year TINYINT;
 DECLARE month_of_year TINYINT;
 DECLARE day_of_week TINYINT;
 SELECT DAY(d) INTO day_of_year;
 SELECT MONTH(d) INTO month_of_year;
 SELECT WEEKDAY(d) INTO day_of_week;
 
 IF day_of_year = 1 AND month_of_year = 1 THEN RETURN 'New Year\'s Day';
 ELSEIF day_of_year = 4 AND month_of_year = 7 THEN RETURN 'Independence Day';
 ELSEIF day_of_week = 0 AND month_of_year = 5 AND day_of_year BETWEEN 22 
 AND 31 THEN RETURN 'Memorial Day';
 ELSEIF day_of_week = 0 AND month_of_year = 9 AND day_of_year BETWEEN 1 
 AND 7 THEN RETURN 'Labor Day';
 ELSEIF day_of_week = 3 AND month_of_year = 11 AND day_of_year BETWEEN 22 
 AND 28 THEN RETURN 'Thanksgiving';
 ELSE RETURN NULL;
 END IF;
END !
-- Back to the standard SQL delimiter
DELIMITER ;

-- SELECT test_date, holiday, is_holiday(test_date) FROM test_dates;

-- USE university;
-- [Problem 2a]

SELECT COUNT(*) AS num_submissions, is_holiday(DATE(sub_date)) AS holiday 
FROM fileset
GROUP BY is_holiday(DATE(sub_date));

-- [Problem 2b]

SELECT COUNT(*) AS num_submissions, CASE 
WHEN is_weekend(DATE(sub_date)) = 1 THEN 'weekend'
ELSE 'weekday'
END AS weekend_or_weekday FROM fileset
GROUP BY weekend_or_weekday;


