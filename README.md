# GNSS-SDR Dockerfile

This repository contains a Dockerfile that creates a [Docker](https://www.docker.com/) image with [GNSS-SDR](https://gnss-sdr.org) and its dependencies installed via ```.deb``` packages. This includes [GNU Radio](https://gnuradio.org/) and drivers for a wide range of RF front-ends through [UHD](https://github.com/EttusResearch/uhd), [gr-osmosdr](http://osmocom.org/projects/sdr/wiki/GrOsmoSDR) and [gr-iio](https://github.com/analogdevicesinc/gr-iio).

This image uses [baseimage-docker](https://github.com/phusion/baseimage-docker), a special Docker image that is configured for correct use within Docker containers. It is Ubuntu, plus:

  * Modifications for Docker-friendliness.
  * Administration tools that are especially useful in the context of Docker.
  * Mechanisms for easily running multiple processes, without violating the Docker philosophy.
  * It only consumes 9 MB of RAM.

If you still have not done so, [install Docker](https://docs.docker.com/engine/getstarted/step_one/) and [verify your installation](https://docs.docker.com/engine/getstarted/step_three/).

Pull docker image
-----------

You can download (pull) the image via following command:

      $ docker pull carlesfernandez/docker-gnsssdr


Build docker image
-----------

Go to the repository directory and run the following command:

     $ docker build -t carlesfernandez/docker-gnsssdr .


Run docker image
-----------

Run:

    $ docker run -it carlesfernandez/docker-gnsssdr

### Run with graphical environment:

 * **On GNU/Linux host machines with X11 server installed**

   In the host machine, adjust the permission of the X server host by the following command:

       $ xhost +local:root

   Then run the container with:

       $ sudo docker run -e DISPLAY=$DISPLAY -v $HOME/.Xauthority:/root/.Xauthority \
       --net=host -it carlesfernandez/docker-gnsssdr

   In case you want to revoke the granted permission:

       $ xhost -local:root

 * **On MacOS host machines**

   Do this once:
     - Install the latest [XQuartz](https://www.xquartz.org/) version and run it.
     - Activate the option "[Allow connections from network clients](https://blogs.oracle.com/oraclewebcentersuite/running-gui-applications-on-native-docker-containers-for-mac)" in XQuartz settings.
     - Quit and restart XQuartz to activate the setting.

   In the host machine:

       $ xhost + 127.0.0.1

   Then run the container with:

       $ docker run -e DISPLAY=host.docker.internal:0 -v $HOME/.Xauthority:/root/.Xauthority \
       --net=host -it carlesfernandez/docker-gnsssdr

 * **Test it!**

   In the container:

       root@ubuntu:/home# gnuradio-companion
