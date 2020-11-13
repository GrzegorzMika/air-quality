from email import send_email, compose_email


def main():
    message = compose_email('g.w.mika@gmail.com', 'Script')
    send_email(message)


if __name__ == '__main__':
    main()
