import json
import logging
import os

from .email import compose_email, send_email
from .utils import find


def main():
    with open(find('mail_setup.json', '/')) as f:
        setup = json.load(f)

    to = setup.get('to')

    # logging.basicConfig(filename=os.path.join(setup.get('log_storage'), 'log.log'), level=logging.INFO,
    #                     format='%(asctime)s %(levelname)s %(name)s %(message)s')
    # logger = logging.getLogger(__name__)

    message = compose_email(to, 'Alert notification')
    send_email(message)


if __name__ == '__main__':
    main()
