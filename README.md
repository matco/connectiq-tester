# ConnectIQ Tester

ConnectIQ Tester is a Docker image that can be used to run the tests "Run No Evil" of a ConnectIQ application. The image contains the SDK, the device bits and the simulator.

The image currently contains ConnectIQ SDK version `8.1.1` and the device files retrieved on `2025-05-18`.

## Usage

The image requires to bind the code of your application to a folder in the container and to set the working directory of the container to the same folder.

The Docker command has 2 optional parameters:
* device_id: the id of one device supported by your application, as listed in your `manifest.xml` file, that will be used to run the tests. If you don't specify a device id, it will default to `fenix7`.
* certificate_path: the path of the certificate that will be used to compile the application relatively to the folder of your application. If you don't provide one, a temporary certificate will be generated automatically.


The simplest command is the following:
```
docker run -v /path/to/your/app:/app -w /app ghcr.io/matco/connectiq-tester:latest
```
The flag `-v` binds the folder containing your application to the `app` folder in the container. The flag `-w` tells the container to work in this repository (it is the working directory). It is required that the working directory matches the path where you bound your application in the container. With this command, a temporary certificate will be created, and the application will be tested using a Fenix 7.


If you want to specify a difference device, just run:
```
docker run -v /path/to/your/app:/app -w /app ghcr.io/matco/connectiq-tester:latest venu2
```
In this case, the application will be tested using a Venu 2.

To specify your own certificate, just run:
```
docker run -v /path/to/your/app:/app -w /app ghcr.io/matco/connectiq-tester:latest venu2 certificate/key.der
```
In this case, the application will be tested using a Venu 2 and the certificate used to compile the application will be `/path/to/your/app/certificate/key.der`.

## Copyright

All the resources contained in the archive `devices.zip` are the property of Garmin. These resources have been fetched from the Garmin website and have been included in this repository to facilitate the creation of the Docker image.
