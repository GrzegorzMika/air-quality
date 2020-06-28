import json
import logging
import os

from datetime import datetime
from sensors import Humidity, Temperature
from utils import find, connect_database, catch_measurement


def main():
    with open(find('setup.json', '/')) as f:
        setup = json.load(f)

    logging.basicConfig(filename=os.path.join(setup.get('log_storage'), 'log.log'), level=logging.INFO,
                        format='%(asctime)s %(levelname)s %(name)s %(message)s')
    logger = logging.getLogger(__name__)

    period = setup.get('period')
    wait = setup.get('wait')
    humidity_port = setup['sensors'].get('humidity_port')
    temperature_port = setup['sensors'].get('temperature_port')

    database = setup.get('database')
    username = setup.get('username')
    password = setup.get('password')

    mydb, mycursor = connect_database(username, password)

    humidity_sensor = Humidity(humidity_port)
    temperature_sensor = Temperature(temperature_port)

    mycursor.execute("USE {}".format(database))

    while True:
        humidity, temperature = catch_measurement(sensor=[humidity_sensor, temperature_sensor], period=period,
                                                  wait=wait)

        now = datetime.now()
        now = str(now.strftime("%Y-%m-%d %H:%M:%S"))

        query_humidity = 'INSERT INTO humidity ( timestamp, humidity ) VALUES ( \"{}\", \"{}\" );'.format(now, humidity)
        query_temperature = 'INSERT INTO temperature ( timestamp, temperature ) VALUES ( \"{}\", \"{}\" );'.format(now,
                                                                                                                   temperature)

        mycursor.execute(query_humidity)
        mycursor.execute(query_temperature)

        mydb.commit()


if __name__ == '__main__':
    main()
