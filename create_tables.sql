CREATE DATABASE IF NOT EXISTS air;

USE air;

CREATE TABLE IF NOT EXISTS humidity
(
  timestamp       datetime NOT NULL,
  humidity        float NOT NULL,
  PRIMARY KEY     (timestamp)
);

CREATE TABLE IF NOT EXISTS temperature
(
  timestamp       datetime NOT NULL,
  temperature     float NOT NULL,
  PRIMARY KEY     (timestamp)
);