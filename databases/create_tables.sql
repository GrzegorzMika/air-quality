CREATE DATABASE IF NOT EXISTS air;

USE air;

-- BASE TABLES

CREATE TABLE IF NOT EXISTS humidity
(
  timestamp       DATETIME, NOT NULL,
  humidity        FLOAT NOT NULL,
  PRIMARY KEY     (timestamp)
);

CREATE TABLE IF NOT EXISTS temperature
(
  timestamp       DATETIME NOT NULL,
  temperature     FLOAT NOT NULL,
  PRIMARY KEY     (timestamp)
);

-- NOTIFICATIONS

CREATE TABLE IF NOT EXISTS notifications
(
    timestamp    DATETIME NOT NULL,
    sensor       VARCHAR(120),
    info         VARCHAR(255),
    PRIMARY KEY  (timestamp)
);

-- AUXILIARY TABLES

CREATE TABLE IF NOT EXISTS warnings
(
    ID          INT NOT NULL AUTO_INCREMENT,
    timestamp   DATETIME NOT NULL,
    message     VARCHAR(120),
    value       FLOAT NOT NULL,
    PRIMARY KEY (ID)
);


CREATE OR REPLACE TABLE messages
(
    ID           TINYINT NOT NULL AUTO_INCREMENT,
    humidity_low VARCHAR(120),
    humidity_high VARCHAR(120),
    temperature_low VARCHAR(120),
    temperature_high VARCHAR(120),
    PRIMARY KEY (ID)
);

CREATE OR REPLACE TABLE thresholds
(
    ID           TINYINT NOT NULL AUTO_INCREMENT,
    humidity_low FLOAT NOT NULL,
    humidity_high FLOAT NOT NULL,
    temperature_low FLOAT NOT NULL,
    temperature_high FLOAT NOT NULL,
    PRIMARY KEY (ID)
);

-- DEFAULT VALUES

INSERT INTO messages (
    humidity_low, humidity_high, temperature_low, temperature_high)
VALUES (

    "Humidity is too low!",
    "Humidity is too high!",
    "Temperature is too low!",
    "Temperature is too high!"
);

INSERT INTO thresholds (
    humidity_low, humidity_high, temperature_low, temperature_high)
VALUES (
    30, 90, 18, 30
);

-- TRIGGERS

DELIMITER //
CREATE OR REPLACE TRIGGER temperature_high
AFTER INSERT
   ON temperature FOR EACH ROW
BEGIN
   DECLARE threshold float;
   DECLARE message varchar(120);
   DECLARE new_value float;
   SELECT temperature_high FROM thresholds ORDER BY ID DESC LIMIT 1 INTO threshold;
   SELECT temperature_high FROM messages ORDER BY ID DESC LIMIT 1 INTO message;
   SELECT NEW.temperature INTO new_value;
   IF (new_value > threshold)
   THEN
            INSERT INTO warnings
            (
                timestamp, message, value
            )
            VALUES
            (
                SYSDATE(), message, new_value
            );
   END IF;
END;//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER temperature_low
AFTER INSERT
   ON temperature FOR EACH ROW
BEGIN
   DECLARE threshold float;
   DECLARE message varchar(120);
   DECLARE new_value float;
   SELECT temperature_low FROM thresholds ORDER BY ID DESC LIMIT 1 INTO threshold;
   SELECT temperature_low FROM messages ORDER BY ID DESC LIMIT 1 INTO message;
   SELECT NEW.temperature INTO new_value;
   IF (new_value < threshold)
   THEN
            INSERT INTO warnings
            (
                timestamp, message, value
            )
            VALUES
            (
                SYSDATE(), message, new_value
            );
   END IF;
END;//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER humidity_high
AFTER INSERT
   ON humidity FOR EACH ROW
BEGIN
   DECLARE threshold float;
   DECLARE message varchar(120);
   DECLARE new_value float;
   SELECT humidity_high FROM thresholds ORDER BY ID DESC LIMIT 1 INTO threshold;
   SELECT humidity_high FROM messages ORDER BY ID DESC LIMIT 1 INTO message;
   SELECT NEW.humidity INTO new_value;
   IF (new_value > threshold)
   THEN
            INSERT INTO warnings
            (
                timestamp, message, value
            )
            VALUES
            (
                SYSDATE(), message, new_value
            );
   END IF;
END;//
DELIMITER ;

DELIMITER //
CREATE OR REPLACE TRIGGER humidity_low
AFTER INSERT
   ON humidity FOR EACH ROW
BEGIN
   DECLARE threshold float;
   DECLARE message varchar(120);
   DECLARE new_value float;
   SELECT humidity_low FROM thresholds ORDER BY ID DESC LIMIT 1 INTO threshold;
   SELECT humidity_low FROM messages ORDER BY ID DESC LIMIT 1 INTO message;
   SELECT NEW.humidity INTO new_value;
   IF (new_value < threshold)
   THEN
            INSERT INTO warnings
            (
                timestamp, message, value
            )
            VALUES
            (
                SYSDATE(), message, new_value
            );
   END IF;
END;//
DELIMITER ;