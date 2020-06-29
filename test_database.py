from sensors import Temperature
from utils import catch_measurement
from datetime import datetime
import mysql.connector

moisture_sensor = Temperature(12)
sensor2 = Temperature(12)

mydb = mysql.connector.connect(
    host="localhost",
    user="grzegorz",
    password="loldupa77."
)
mycursor = mydb.cursor()

mycursor.execute("USE agriculture")

for i in range(10):
    now = datetime.now()
    m1, m2 = catch_measurement([moisture_sensor, sensor2], 1, 50)
    query = 'INSERT INTO moisture ( timestamp, moisture ) VALUES ( \"{}\", \"{}\" );'.format(str(now.strftime("%Y-%m-%d %H:%M:%S")),
                                                                                     m1)
    print(query)
    mycursor.execute(query)
    mydb.commit()
