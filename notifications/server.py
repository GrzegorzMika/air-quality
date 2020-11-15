import logging
import os
import re
from datetime import datetime, timedelta

import mysql.connector


def sql_credentials():
    """
    Load SQL server login credentials and the IP address from environmental variables.
    :return: Name, password and IP address of the SQL server.
    """
    user = os.environ['MYSQL_USER']
    password = os.environ['MYSQL_PASSWORD']
    host = os.environ['MYSQL_HOST']

    return user, password, host


def connect_database(username, password, database, host, port="3306"):
    """
    Create connection to a MySQL database.
    :param username: Name of the user
    :param password: User's password
    :param database: Name of the database to connect.
    :param host: IP address of the MySQL server.
    :param port: Port to which MySQL server is listening, default is 3306 (default MySQL server port)
    :return: database connection object and database cursor object
    """
    mydb = mysql.connector.connect(
        host=host,
        user=username,
        password=password,
        port=port,
        database=database
    )
    mycursor = mydb.cursor()
    return mydb, mycursor


def parse_relaxation(relaxation):
    """
    Helper function to verify if time format is as expected and to split it.
    :param relaxation: string representing the grace period
    :return: tuple consisting of integers representing the hour, minute and second
    """
    assert re.match(r"[0-9][0-9]:[0-9][0-9]:[0-9][0-9]", relaxation), 'Relaxation is expected in a form HH:MM:SS, ' \
                                                                      'but {} was provided'.format(relaxation)

    split = relaxation.split(':')
    return int(split[0]), int(split[1]), int(split[2])


def check_if_sent(cursor, database, sensor, relaxation):
    """
    Verify if the notification for given sensor was sent or not within the period specified by relaxation.
    :param cursor: cursor to database connection
    :param database: database connection
    :param sensor: name of the sensor for which the notifications are being sent, must coincide with the name of a table
    :param relaxation: string representing the grace period
    :return: True if the notification was sent within the period specified by relaxation, False otherwise
    """
    hour, minute, second = parse_relaxation(relaxation)
    time_shift = datetime.now() - timedelta(hours=hour, minutes=minute, seconds=second)

    query = "SELECT * " \
            "FROM {}.notifications " \
            "WHERE sensor = \"{}\" AND timestamp >= \"{}\" " \
            "ORDER BY timestamp DESC " \
            "LIMIT 1".format(database, sensor, time_shift)
    try:
        cursor.execute(query)
        results = cursor.fetchall()
    except Exception as e:
        logging.error(e)
        results = []

    if results:
        return True
    else:
        return False


def store_info(cursor, database, sensor, info='Notification sent!'):
    """
    Store the info about sent notifications for a given sensor.
    :param cursor: cursor to the database connection
    :param database: database connection
    :param sensor: name of the sensor for which the notification are being sent, must coincide with the table name
    :param info: additional information to store with each recorded notification
    """
    time = datetime.now()
    query = "INSERT INTO notifications (timestamp, sensor, info) VALUES (\"{}\", \"{}\", \"{}\")".format(time, sensor,
                                                                                                         info)

    try:
        cursor.execute(query)
        database.commit()
    except Exception as e:
        logging.error(e)


def observe(cursor, database, sensor, lower_threshold, upper_threshold):
    """
    Observe the level of a given sensor and verify if it is between thresholds.
    :param cursor: cursor to database connection
    :param database: database connection
    :param sensor: name of the sensor for which the notification are being sent, must coincide with the table name
    :param lower_threshold: upper bound for allowed values for a sensor value
    :param upper_threshold: lower bound for allowed values for a sensor value
    :return: tuple of logical indicator if any of thresholds is crossed and the measurement value
    """
    query = "SELECT * " \
            "FROM {}.{} " \
            "ORDER BY timestamp DESC " \
            "LIMIT 1".format(database, sensor)

    try:
        cursor.execute(query)
        results = cursor.fetchall()
    except Exception as e:
        logging.error(e)
        results = [(datetime.now, -1)]

    value = results[0][1]

    return value < lower_threshold or value > upper_threshold, value
