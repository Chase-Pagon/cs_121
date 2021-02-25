-- [Problem 1]
DROP TABLE IF EXISTS participated, owns;
DROP TABLE IF EXISTS person, car, accident;

-- Creates table person with driver_id which is a length 10 char that
-- represents drivers license. Name is the name of the person. Address is
-- the address of the person.

CREATE TABLE person (
driver_id CHAR(10) PRIMARY KEY,
name VARCHAR(15) NOT NULL,
address VARCHAR(300) NOT NULL
    );

-- Car table is a table of cars with the license being the license plate
-- Model is a up to 100 character description of the model of the car.
-- Year is the year of the model of the car.

CREATE TABLE car(
license CHAR(7) PRIMARY KEY,
model VARCHAR(100),
year YEAR
);

-- Accident table is a table of accidents. Report number is an auto increasing
-- INT. Date occured is the date the accident happened. Location is a up to
-- 300 character description of where the accident occured. Description is 
-- a MEDIUMTEXT of a report of the incident in a formal write up.

CREATE TABLE accident (
report_number INT AUTO_INCREMENT PRIMARY KEY,
date_occured DATETIME NOT NULL,
location VARCHAR(300) NOT NULL,
description MEDIUMTEXT
);

-- Owns table is a table of who owns each car. The foreign key driver_id
-- references the person who owns the car. The foreign key license references
-- the car in which the person owns.

CREATE TABLE owns (
driver_id CHAR(10),
license CHAR(7),
PRIMARY KEY (driver_id, license),
FOREIGN KEY (driver_id) REFERENCES person(driver_id)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (license) REFERENCES car(license)
ON DELETE CASCADE ON UPDATE CASCADE
);

-- Participated table is a table of which parties participated in the accident
-- The foreign key driver_id references the person who owns the car. The 
-- foreign key license references the car in which the person owns. The
-- foreign key report_number references the accident in which this happened
-- Lastly, damage_amount is a NUMERIC which represents the amount that the
-- accident costs.

CREATE TABLE participated (
driver_id CHAR(10),
license CHAR(7),
report_number INT,
damage_amount NUMERIC(14, 2),
PRIMARY KEY (driver_id, license, report_number),
FOREIGN KEY (driver_id) REFERENCES person(driver_id)
ON UPDATE CASCADE,
FOREIGN KEY (license) REFERENCES car(license)
ON UPDATE CASCADE,
FOREIGN KEY (report_number) REFERENCES accident(report_number)
ON UPDATE CASCADE
);

    