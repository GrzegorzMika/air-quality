import logging
import os
import smtplib
from email.message import EmailMessage


def email_credentials():
    user = os.environ['AIR_QUALITY_USER']
    password = os.environ['AIR_QUALITY_PASSWORD']

    return user, password


def compose_email(to, subject):
    user, _ = email_credentials()
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
    user, password = email_credentials()

    try:
        with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp:
            smtp.login(user, password)
            smtp.send_message(message)
        logging.info('Message sent successfully.')
    except Exception as e:
        logging.error(e)
