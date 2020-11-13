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
    assert re.match(r"[0-9][0-9]:[0-9][0-9]:[0-9][0-9]", relaxation), 'Relaxation is expected in a form HH:MM:SS, ' \
                                                                      'but {} was provided'.format(relaxation)

    split = relaxation.split(':')
    return int(split[0]), int(split[1]), int(split[2])


def check_if_sent(cursor, database, sensor, relaxation):
    hour, minute, second = parse_relaxation(relaxation)
    time_shift = datetime.now() - timedelta(hours=hour, minutes=minute, seconds=second)

    query = "SELECT * " \
            "FROM {}.notifications " \
            "WHERE sensor = {} AND timestamp >= {}" \
            "ORDER BY timestamp DESC" \
            "LIMIT 1".format(database, sensor, time_shift)

    cursor.execute(query)
    results = cursor.fetchall()

    if results:
        return True
    else:
        return False
