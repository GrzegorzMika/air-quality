import logging
import os
import time
from collections import defaultdict
import mysql.connector


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


def connect_database(username, password, host='database'):
    mydb = mysql.connector.connect(
        host=host,
        user=username,
        password=password
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
            logging.error(e)
        finally:
            time.sleep(wait)

    measurement = []
    for i, _ in enumerate(sensor):
        measurement.append(sum(measurement_temporary['sensor_' + str(i)]) / len(measurement_temporary['sensor_' + str(i)]))
    return measurement

