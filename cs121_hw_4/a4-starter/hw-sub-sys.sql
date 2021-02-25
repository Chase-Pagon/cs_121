-- [Problem 1a]

SELECT SUM(perfectscore) as perfect_score FROM assignment;

-- [Problem 1b]

SELECT sec_name, COUNT(*) as total_students FROM section 
NATURAL JOIN student GROUP BY sec_name;

-- [Problem 1c]

CREATE VIEW totalscores AS SELECT username, SUM(score) as total_score
FROM submission WHERE graded != 0 GROUP BY username;

-- [Problem 1d]

CREATE VIEW passing AS SELECT * FROM totalscores
WHERE total_score >= 40;

-- [Problem 1e]

CREATE VIEW failing AS SELECT * FROM totalscores
WHERE total_score < 40;

-- [Problem 1f]

SELECT username FROM passing NATURAL JOIN 
(SELECT * FROM submission NATURAL JOIN assignment WHERE shortname LIKE 'lab%')
as t
NATURAL LEFT JOIN fileset WHERE fileset.sub_id IS NULL;

-- harris, ross, miller, turner, edwards, murphy, simmons, tucker, coleman,
-- flores, gibson

-- [Problem 1g]

SELECT username FROM passing NATURAL JOIN 
(SELECT * FROM submission NATURAL JOIN assignment 
WHERE shortname = 'final' OR shortname = 'midterm') as t
NATURAL LEFT JOIN fileset WHERE fileset.sub_id IS NULL;

-- collins

-- [Problem 2a]

SELECT DISTINCT username FROM student NATURAL JOIN 
(SELECT * FROM submission NATURAL JOIN assignment WHERE shortname = 'midterm')
 as t NATURAL JOIN fileset
WHERE sub_date > due;

-- [Problem 2b]

SELECT EXTRACT(HOUR FROM sub_date) AS hour, COUNT(sub_id) AS num_submits FROM
fileset NATURAL JOIN 
(SELECT * FROM submission NATURAL JOIN assignment WHERE shortname LIKE 'lab%')
as t
GROUP BY EXTRACT(HOUR FROM sub_date) ORDER BY hour;

-- [Problem 2c]

SELECT COUNT(*) AS num_final FROM
fileset NATURAL JOIN 
(SELECT * FROM submission NATURAL JOIN assignment WHERE shortname = 'final')
as t
WHERE sub_date < due
AND sub_date > due - INTERVAL 30 MINUTE;

-- [Problem 3a]

ALTER TABLE student
ADD email varchar(200);

UPDATE student SET email = CONCAT(username, '@school.edu');

ALTER TABLE student MODIFY email varchar(200) NOT NULL;

-- [Problem 3b]

ALTER TABLE assignment
ADD submit_files TINYINT DEFAULT 1;

UPDATE assignment SET submit_files = 0 WHERE shortname LIKE 'dq%';

-- [Problem 3c]

CREATE TABLE gradescheme(
scheme_id INTEGER PRIMARY KEY,
scheme_desc varchar(100) NOT NULL
);

INSERT INTO gradescheme VALUES
( 0, 'Lab assignment with min-grading.'),
( 1, 'Daily quiz.' ),
( 2, 'Midterm or final exam.');

ALTER TABLE assignment
RENAME COLUMN gradescheme TO scheme_id;

ALTER TABLE assignment MODIFY scheme_id INTEGER NOT NULL;

ALTER TABLE assignment ADD FOREIGN KEY (scheme_id) 
REFERENCES gradescheme(scheme_id);
