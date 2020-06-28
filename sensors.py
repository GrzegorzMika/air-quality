from abc import ABCMeta, abstractmethod

from seeed_dht import DHT


class Sensor(metaclass=ABCMeta):
    @abstractmethod
    def __init__(self):
        ...

    @abstractmethod
    def measurement(self):
        ...


class Temperature(Sensor):
    def __init__(self, port):
        """
        Wrapper for Grove Temperature sensor.
        :param port: port to which the sensor is connected
        """
        super().__init__()
        self.sensor = DHT("11", port)

    @property
    def measurement(self):
        """
        Get value of the measurement
        """
        _, temperature = self.sensor.read()
        return temperature


class Humidity(Sensor):
    def __init__(self, port):
        """
        Wrapper for Grove Humidity sensor.
        :param port: port to which the sensor is connected
        """
        super().__init__()
        self.sensor = DHT("11", port)

    @property
    def measurement(self):
        """
        Get value of the measurement
        """
        humidity, _ = self.sensor.read()
        return humidity
