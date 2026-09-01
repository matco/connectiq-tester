# ConnectIQ Tester

ConnectIQ Tester is a Docker image that can be used to run the tests "Run No Evil" of a ConnectIQ application. The image contains the SDK, the device bits, the device fonts and the simulator.

The image currently contains ConnectIQ SDK version `9.2.0` and the device files retrieved on `2026-08-31`.

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

## Resources

The simulator needs devices (in `~/.Garmin/ConnectIQ/Devices`) and fonts (in `~/.Garmin/ConnectIQ/Fonts`) files.

These files are too large and are the property of Garmin, so they are not versioned in this repository. Instead, they are published in a dedicated image, `ghcr.io/matco/connectiq-tester-resources`, from which the tester image copies them at build time. This image is built manually, using the ConnectIQ folder of a local SDK Manager installation as the build context:
```
docker build -f resources/Dockerfile -t ghcr.io/matco/connectiq-tester-resources:2026-08-31 "$HOME/.Garmin/ConnectIQ"
docker push ghcr.io/matco/connectiq-tester-resources:2026-08-31
```

The tag of the resources image used by the tester image is the `RESOURCES_VERSION` build argument of the `Dockerfile`.

## Copyright

All the resources contained in the images `ghcr.io/matco/connectiq-tester-resources` are the property of Garmin. These resources have been fetched from the Garmin website and have been published to facilitate the creation of the Docker image.
