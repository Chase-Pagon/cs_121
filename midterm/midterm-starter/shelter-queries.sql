-- [Problem 1]

SELECT animals.name, animal_type, notes, shelters.name AS shelter_name
 FROM animals LEFT JOIN shelters ON animals.shelter_id = shelters.shelter_id
 WHERE UPPER (notes) LIKE UPPER('%Bonded Pair%');

-- [Problem 2]

CREATE VIEW shelter_applications 
AS SELECT app_id, applicant_id, animal_id, shelter_id FROM
applications NATURAL LEFT JOIN animals;

-- [Problem 3]

SELECT shelters.name, COUNT(app_id) AS total_apps, 
COUNT(CASE status WHEN 'Accepted' THEN 1 ELSE NULL END) AS accepted_apps
FROM applications NATURAL LEFT JOIN animals LEFT JOIN shelters
ON animals.shelter_id = shelters.shelter_id
GROUP BY shelters.shelter_id
ORDER BY total_apps DESC, accepted_apps DESC;

-- [Problem 4]

SELECT employees.name, animals.animal_id, animals.name, animals.animal_type
FROM applicants NATURAL JOIN employees NATURAL JOIN applications JOIN animals
 ON animals.animal_id = applications.animal_id;

-- [Problem 5]

-- Cascade on delete should cover the applications that reference animal_id
DELETE FROM animals WHERE animal_type = 'Rock';

-- [Problem 6]

DROP TABLE IF EXISTS previous_applications;

CREATE TABLE previous_applications(
app_id SERIAL PRIMARY KEY,
applicant_id BIGINT UNSIGNED NOT NULL,
FOREIGN KEY (applicant_id) REFERENCES applicants(applicant_id)
ON DELETE CASCADE ON UPDATE CASCADE,
animal_id BIGINT UNSIGNED NOT NULL,
FOREIGN KEY (animal_id) REFERENCES animals(animal_id)
ON DELETE CASCADE, 
status VARCHAR(15) NOT NULL, 
application_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO previous_applications SELECT * FROM applications
WHERE status = 'Accepted' OR status = 'Rejected';

DELETE FROM applications WHERE status = 'Accepted' OR status = 'Rejected';

-- [Problem 7]

DELIMITER !
-- Given a date value, returns 1 if it is a weekend,
-- or 0 if it is a weekday.
CREATE FUNCTION count_type(a_t VARCHAR(50)) RETURNS INT DETERMINISTIC
BEGIN
DECLARE type_count INT;
 IF a_t = 'Other' THEN SELECT COUNT(*) FROM animals 
 WHERE NOT (animal_type = 'Cat' OR animal_type = 'Dog') INTO type_count;
 ELSE SELECT COUNT(*) FROM animals WHERE animal_type = a_t INTO type_count;
 END IF;
 RETURN type_count;
END !
-- Back to the standard SQL delimiter
DELIMITER ;


-- [Problem 8]

CREATE VIEW animal_types AS SELECT animal_type, 
count_type(animal_type) as animal_count
FROM animals WHERE animal_type = 'Dog' OR animal_type = 'Cat'
UNION SELECT 'Other animals', count_type('Other');

-- [Problem 9]

DELIMITER !
CREATE PROCEDURE accept_adoption (a_id BIGINT, applier_id BIGINT)
BEGIN
DECLARE updated INT;
SELECT COUNT(*) FROM applications 
WHERE applicant_id = applier_id INTO updated;
IF updated > 0 THEN
UPDATE applications SET status = 'Accepted' 
WHERE applicant_id = applier_id AND animal_id = a_id;
UPDATE applications SET status = 'Rejected' 
WHERE applicant_id <> applier_id AND animal_id = a_id;
UPDATE animals SET notes = CONCAT('Adoption approved for ', applier_id) 
WHERE animal_id = a_id;
END IF;
END !
DELIMITER ;

-- [Problem 10]

DELIMITER !
CREATE PROCEDURE nearby_animals 
(zip CHAR(5), OUT num_shelters INT, OUT num_animals INT)
BEGIN
SELECT COUNT(*) FROM shelters WHERE zipcode 
LIKE CONCAT(SUBSTRING(zip, 1, 3), '%') INTO num_shelters;
SELECT COUNT(*) FROM animals JOIN shelters 
ON animals.shelter_id = shelters.shelter_id 
WHERE zipcode LIKE CONCAT(SUBSTRING(zip, 1, 3), '%') INTO num_animals;
END !
DELIMITER ;

-- [Problem XC (Optional)]

-- The belongings table is so that the employees in the shelter can keep track
-- of what items belong to which animals. Obviously it has a name, then a type
-- like food, toy, etc. An accquired date so when the animal first got it.
-- Foreign key of animal_id because that is who it belongs to and lastly
-- any notes like this is their favorite toy or food, adds personality to the
-- animal

CREATE TABLE belongings (
belonging_id SERIAL PRIMARY KEY,
name VARCHAR(100) NOT NULL,
belonging_type VARCHAR(100) NOT NULL,
accquired DATETIME,
FOREIGN KEY (animal_id) REFERENCES animals(animal_id)
ON DELETE CASCADE, 
notes TEXT
);

INSERT INTO belongings VALUES
('chewy squeaky toy', 'Toy', NULL, 5, 'This is their favorite toy, they love
to chew on it all day :)');

