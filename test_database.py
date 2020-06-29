from sensors import Temperature
from utils import catch_measurement
from datetime import datetime
import mysql.connector

moisture_sensor = Temperature(12)

mydb = mysql.connector.connect(
    host="localhost",
    user="grzegorz",
    password="loldupa77."
)
mycursor = mydb.cursor()

mycursor.execute("USE agriculture")

for i in range(10):
    now = datetime.now()
    measurement = catch_measurement([moisture_sensor], 1, 1)
    query = 'INSERT INTO moisture ( timestamp, moisture ) VALUES ( \"{}\", \"{}\" );'.format(str(now.strftime("%Y-%m-%d %H:%M:%S")),
                                                                                     measurement[0])
    print(query)
    mycursor.execute(query)
    mydb.commit()
