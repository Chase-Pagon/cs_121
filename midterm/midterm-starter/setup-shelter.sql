-- DROP TABLE statements (no CREATE/USE)

DROP TABLE IF EXISTS applications;
DROP TABLE IF EXISTS animals, applicants;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS shelters;

-- Shelter Database Table Definitions

-- Shelters table which is what each animal is tied to. Shelter_id is auto
-- generated BIGINT. Name is the name of the shelter. Address is up to 100
-- character address. Zipcode is 5 digit well zipcode. City is up to 100
-- character city. Lastly state is a 2 character state code.
CREATE TABLE shelters(
shelter_id SERIAL PRIMARY KEY,
name VARCHAR(100) NOT NULL,
address VARCHAR(100) NOT NULL,
zipcode CHAR(5) NOT NULL,
city VARCHAR(100) NOT NULL,
state CHAR(2) NOT NULL
);

-- Employees is the table of employees who work at the shelters. Employee ID
-- is auto generate BIGINT. Name is the persons name. Gender is up to 20
-- characters which describes the persons gender. Is_volunteer is either 0
-- for volunteer or 1 for not volunteer. Phone is their 10 digit phone number.
-- Email is up to 100 character email. Role is a brief description like Walker
-- or Manager. Join date is the date they signed up. Foreign key shelter_id
-- references the shelter that they work for. Lastly there is a canidate key
-- of name and phone which can uniquely identify an employee.

CREATE TABLE employees(
emp_id SERIAL PRIMARY KEY,
name VARCHAR(100) NOT NULL,
gender VARCHAR(20),
is_volunteer CHAR(1) NOT NULL,
phone CHAR(12) NOT NULL,
email VARCHAR(100) NOT NULL,
role VARCHAR(30) NOT NULL,
join_date DATE NOT NULL,
shelter_id BIGINT UNSIGNED NOT NULL,
FOREIGN KEY (shelter_id) REFERENCES shelters(shelter_id)
ON DELETE CASCADE,
UNIQUE(name, phone)
);

-- Animals table is a table of animals that are registered to a shelter.
-- Animal ID is auto generate BIGINT. Name is up to 100 character name
-- of the animal. Gender is up to a 20 character description of the gender
-- Breed is the breed of the animal, can be null as rock types don't have
-- a breed (but an argument could be made for that Limestone, quarts, etc.
-- Age_est is the estimated age of the animal in years, can be null since
-- sometimes we wouldn't know. Notes is a up to 1000 character notes
-- about an animal. Shelter_id is a foreign key that references which
-- shelter they belong to. Join date is the date the animal joined the
-- shelter. Adoption price is a decimal value up to 1000 that represents
-- the cost to adopt the animal.

CREATE TABLE animals(
animal_id SERIAL PRIMARY KEY, 
name VARCHAR(100) NOT NULL, 
gender VARCHAR(20), 
animal_type VARCHAR(50) NOT NULL, 
breed VARCHAR(100), 
age_est INT, 
notes VARCHAR(1000),
shelter_id BIGINT UNSIGNED NOT NULL,
FOREIGN KEY (shelter_id) REFERENCES shelters(shelter_id)
ON DELETE CASCADE,
join_date DATE NOT NULL,
adoption_price NUMERIC(5, 2)
);


-- Applicants table is a table of people who have applied to adopt an animal.
-- Applicant ID is an auto generate BIGINT. Name is the name of the person
-- who applied. Phone is a 10 digit phone number. Address is an up to 100
-- character representation of their address. Zipcode is their 5 digit zipcode
-- Curr_pet_count is the number of pets that this person currently has.
-- Household_size is the number of humans that live in their household.
-- Notes is an up to 1000 character description of what kind of pet their
-- lokking for. Lastly, their is a canidate key of name and phone which
-- can be used to uniquely identify an applicant.
CREATE TABLE applicants(
applicant_id SERIAL PRIMARY KEY, 
name VARCHAR(100) NOT NULL, 
phone CHAR(12) NOT NULL, 
address VARCHAR(100) NOT NULL, 
zipcode CHAR(5) NOT NULL, 
curr_pet_count INT NOT NULL, 
household_size INT NOT NULL, 
notes VARCHAR(1000),
UNIQUE(name, phone)
);


-- Applications table is a table of applications that have been submitted by
-- an applicant. App_id is an auto generated BIGINT. Applicant_id is a
-- foreign key which references the id of the person who submitted the
-- application. Animal_id is a foreign key which references the animal that
-- this application was submited for to adopt. Status is an up to 15 character
-- brief description of the status of the application, like Accepted or
-- Rejected. Lastly, application_date is the timestamp that the application
-- was submitted.
CREATE TABLE applications(
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