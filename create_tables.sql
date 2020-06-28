CREATE DATABASE air;

USE air;

CREATE TABLE humidity
(
  timestamp       datetime NOT NULL,
  humidity        float NOT NULL,
  PRIMARY KEY     (timestamp)
);

CREATE TABLE temperature
(
  timestamp       datetime NOT NULL,
  temperature     float NOT NULL,
  PRIMARY KEY     (timestamp)
);