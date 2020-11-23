import json
import logging
import os

from twisted.internet import task, reactor
from email_utils import compose_email, send_email
from server import observe, check_if_sent, store_info, sql_credentials, connect_database
from utils import find


def notification_logic(username, password, host, database, sensor, lower_threshold, upper_threshold, relaxation, to):
    mydb, cursor = connect_database(username, password, database, host)
    crossed, value = observe(cursor, database, sensor, lower_threshold, upper_threshold)
    if crossed and not check_if_sent(cursor, database, sensor, relaxation):
        store_info(mydb, cursor, sensor)
        message = compose_email(to, 'Alert notification', sensor, value)
        send_email(message)
    cursor.close()
    mydb.close()


def main():
    with open(find('mail_setup.json', '/')) as f:
        setup = json.load(f)

    logging.basicConfig(filename=os.path.join(setup.get('log_storage'), 'log.log'), level=logging.INFO,
                        format='%(asctime)s %(levelname)s %(name)s %(message)s')

    to = setup.get('to')
    wait = setup.get('wait')
    relaxation = setup.get('relaxation')
    database = setup.get('database')
    sensor = setup.get('observed')
    lower_threshold, upper_threshold = setup.get('threshold')
    username, password, host = sql_credentials()

    def wrap_logic():
        return notification_logic(username, password, host, database,
                                  sensor, lower_threshold, upper_threshold, relaxation, to)

    loop = task.LoopingCall(wrap_logic)
    loop.start(wait)

    reactor.run()


if __name__ == '__main__':
    main()
