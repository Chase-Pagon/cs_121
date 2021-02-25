-- [Problem 2a]
INSERT INTO person (driver_id, name, address)  VALUES
(1234567899, 'Chase', '123 Fairy Lane'),
(1234567891, 'Leah', '321 Caltech'),
(1234567898, 'Rich', '789 Moneybags');
INSERT INTO car (license, model, year) VALUES
('ABCDEFG', 'Lambo', 2023);
INSERT INTO car (license, year) VALUES
('ABCDEFZ', 2023),
('ZBCDEFZ', 2069);
INSERT INTO car (license, model) VALUES
('ABCDEFA', 'Jeep Wrangler');
INSERT INTO accident (date_occured, location, description) VALUES
('2020-01-03 12:56:54', 'On the corner', 'It was a brutal accident'),
('2020-03-03 12:56:54', 'In a school', 'It was fine');
INSERT INTO accident (date_occured, location) VALUES
('2020-07-03 12:56:54', 'On the block in a house');
INSERT INTO owns VALUES
(1234567899, 'ABCDEFA'),
(1234567891, 'ABCDEFG');
INSERT INTO participated VALUES
(1234567899, 'ABCDEFA', 1, 123456),
(1234567891, 'ABCDEFG', 2, 654321);
INSERT INTO participated (driver_id, license, report_number) VALUES
(1234567899, 'ABCDEFA', 3);


-- [Problem 2b]
UPDATE car SET model = 'A cool Jeep Wrangler' WHERE license = 'ABCDEFG';
UPDATE person SET name = 'Cool guy 123' WHERE driver_id = 1234567891;

-- [Problem 2c]

DELETE FROM car WHERE license = 'ABCDEFZ'


