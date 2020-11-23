import logging
import os
import time
from collections import defaultdict
import mysql.connector


def credentials():
    """
    Load SQL server login credentials and the IP address from environmental variables.
    :return: Name, password and IP address of the SQL server.
    """
    user = os.environ['MYSQL_USER']
    password = os.environ['MYSQL_PASSWORD']
    host = os.environ['MYSQL_HOST']

    return user, password, host


def find(name, path):
    """
    Find a file specified by name starting from path.
    :param name: name of the file to be found
    :param path: starting location
    :return: path to the file starting from path
    """
    for root, dirs, files in os.walk(path):
        if name in files:
            return os.path.join(root, name)


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


def catch_measurement(sensor, period, wait):
    """
    Catch the measurement value of a list of sensors. It is an average of period consecutive measurements performed one every
    wait seconds for each sensor.
    :param sensor: list of sensor to read
    :param period: how many measurements to perform before sending the value downstream
    :param wait: how long to wait between consecutive measurements
    :return: list of measurement value averaged in period for each sensor
    """
    measurement_temporary = defaultdict()

    for i, _ in enumerate(sensor):
        measurement_temporary['sensor_' + str(i)] = []

    for _ in range(period):
        try:
            for i, s in enumerate(sensor):
                measurement_temporary['sensor_' + str(i)].append(s.measurement)
        except Exception as e:
            logging.error(e, exc_info=True)
        finally:
            time.sleep(wait)

    measurement = []
    for i, _ in enumerate(sensor):
        measurement.append(sum(measurement_temporary['sensor_' + str(i)]) / len(measurement_temporary['sensor_' + str(i)]))
    return measurement

