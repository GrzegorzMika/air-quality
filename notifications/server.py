import configparser
import logging
import os
import smtplib
from email.message import EmailMessage


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


def _credentials(filename='emails.ini'):
    config = configparser.ConfigParser()
    config.read(find(filename, '../..'))
    user = config['EMAIL']['user']
    password = config['EMAIL']['password']

    return user, password


def compose_email(to, subject):
    user, _ = _credentials()
    content = _write_email_content()

    msg = EmailMessage()
    msg['Subject'] = subject
    msg['From'] = user
    msg['To'] = to
    msg.set_content(content)

    return msg


def _write_email_content():
    return 'This is email content.'


def send_email(message):
    user, psswd = _credentials()

    try:
        with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp:
            print(user,  psswd)
            smtp.login(user, psswd)
            smtp.send_message(message)
        logging.info('Message sent successfully.')
    except Exception as e:
        logging.error(e)


def main():
    message = compose_email('g.w.mika@gmail.com', 'Script')
    send_email(message)


if __name__ == '__main__':
    main()
