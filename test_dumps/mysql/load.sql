DROP DATABASE IF EXISTS test;
CREATE DATABASE IF NOT EXISTS test;
USE test;
SET global local_infile = 1;

CREATE TABLE book(
   id INT NOT NULL AUTO_INCREMENT,
   title VARCHAR(100) NOT NULL,
   author VARCHAR(40) NOT NULL,
   publication_date DATE,
   PRIMARY KEY ( id )
);

LOAD DATA
INFILE '/docker-entrypoint-initdb.d/books.csv'
INTO TABLE book
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
