<!-- prettier-ignore-start -->
[comment]: # (
SPDX-License-Identifier: MIT
)

[comment]: # (
SPDX-FileCopyrightText: 2017-2021 Carles Fernandez-Prades <carles.fernandez@cttc.es>
)
<!-- prettier-ignore-end -->

# GNSS-SDR Dockerfile

This repository contains a Dockerfile that creates a
[Docker](https://www.docker.com/) image with [GNSS-SDR](https://gnss-sdr.org)
and its dependencies installed via `.deb` packages. This includes
[GNU Radio](https://gnuradio.org/) and drivers for a wide range of RF front-ends
through [UHD](https://github.com/EttusResearch/uhd),
[gr-osmosdr](http://osmocom.org/projects/sdr/wiki/GrOsmoSDR) and
[gr-iio](https://github.com/analogdevicesinc/gr-iio).

This image uses [baseimage-docker](https://github.com/phusion/baseimage-docker),
a special Docker image that is configured for correct use within Docker
containers. It is Ubuntu, plus:

- Modifications for Docker-friendliness.
- Administration tools that are especially useful in the context of Docker.
- Mechanisms for easily running multiple processes, without violating the Docker
  philosophy.
- It only consumes 9 MB of RAM.

If you still have not done so,
[install Docker](https://docs.docker.com/engine/getstarted/step_one/) and
[verify your installation](https://docs.docker.com/engine/getstarted/step_three/).

## Pull docker image

You can download (pull) the image via following command:

      $ docker pull carlesfernandez/docker-gnsssdr

## Run docker image

Run:

    $ docker run -it carlesfernandez/docker-gnsssdr

### Run with access to a folder in the host machine

Maybe you want to include a local folder with GNSS raw data to process in your
container, or to extract output files generated during its execution. You can do
that by running the container as:

    $ docker run -it -v /home/user/data:/data carlesfernandez/docker-gnsssdr

This will mount the `/home/user/data` folder in the host machine on the `/data`
folder inside the container, with read and write permissions.

### Run with graphical environment:

- **On GNU/Linux host machines with X11 server installed**

  In the host machine, adjust the permission of the X server host by the
  following command:

      $ xhost +local:root

  Then run the container with:

      $ sudo docker run -e DISPLAY=$DISPLAY -v $HOME/.Xauthority:/root/.Xauthority \
      --net=host -it carlesfernandez/docker-gnsssdr

  In case you want to revoke the granted permission:

      $ xhost -local:root

- **On macOS host machines**

  Do this once:

  - Install the latest [XQuartz](https://www.xquartz.org/) version and run it.
  - Activate the option
    "[Allow connections from network clients](https://blogs.oracle.com/oraclewebcentersuite/running-gui-applications-on-native-docker-containers-for-mac)"
    in XQuartz settings.
  - Quit and restart XQuartz to activate the setting.

  In the host machine:

      $ xhost + 127.0.0.1

  Then run the container with:

      $ docker run -e DISPLAY=host.docker.internal:0 -v $HOME/.Xauthority:/root/.Xauthority \
      --net=host -it carlesfernandez/docker-gnsssdr

- **Test it!**

  In the container:

      root@ubuntu:/home# gnuradio-companion

## Build docker image

This step is not needed if you have pulled the image. If you want to build the
Docker image on you own, go to the repository root folder and run the following
command:

     $ docker build -t carlesfernandez/docker-gnsssdr .

You can change `carlesfernandez/docker-gnsssdr` at your own preference.

## Copyright and License

Copyright: &copy; 2017-2021 Carles Fern&aacute;ndez-Prades. All rights reserved.

The content of this repository is published under the [MIT](./LICENSE) license.

## Acknowledgements

This work was partially supported by the Spanish Ministry of Science,
Innovation, and Universities through the Statistical Learning and Inference for
Large Dimensional Communication Systems (ARISTIDES, RTI2018-099722-B-I00)
project.
