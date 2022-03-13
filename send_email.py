import email
from email import message
import smtplib
#going to create and email send funtion, what will do
#is that I will call this function and it will send email
#for me based on what I asked

def send_email(data):
    gmail_user='majidkhatibshahidi@gmail.com'
    gmail_password='your email password'
    sent_from = gmail_user+data['email']
    to = ['majid.shahidi68@gmail.com']
    subject = 'Hi'
    body = data['message']

    email_text = """\
    From: %s
    To: %s
    Subject: %s

    %s
    """ % (sent_from, ", ".join(to), subject, body)

    try:
        smtp_server = smtplib.SMTP_SSL('smtp.gmail.com', 465)
        smtp_server.ehlo()
        smtp_server.login(gmail_user, gmail_password)
        smtp_server.sendmail(sent_from, to, email_text)
        smtp_server.close()
        print ("Email sent successfully!")
    except Exception as ex:
        print ("Something went wrong….",ex)
