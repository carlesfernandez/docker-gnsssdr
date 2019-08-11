# Use phusion/baseimage as base image.
# See https://github.com/phusion/baseimage-docker/releases
# for a list of version numbers.

FROM phusion/baseimage:0.11
MAINTAINER carles.fernandez@cttc.es

WORKDIR /home/src

RUN apt-get update && apt-get install -y --no-install-recommends \
 build-essential=12.4ubuntu1 \
 cmake=3.10.2-1ubuntu2.18.04.1 \
 libarmadillo-dev=1:8.400.0+dfsg-2 \
 libblas-dev=3.7.1-4ubuntu1 \
 libboost-chrono-dev=1.65.1.0ubuntu1 \
 libboost-dev=1.65.1.0ubuntu1 \
 libboost-date-time-dev=1.65.1.0ubuntu1 \
 libboost-filesystem-dev=1.65.1.0ubuntu1 \
 libboost-serialization-dev=1.65.1.0ubuntu1 \
 libboost-system-dev=1.65.1.0ubuntu1 \
 libboost-thread-dev=1.65.1.0ubuntu1 \
 libgflags-dev=2.2.1-1 \
 libgnutls28-dev=3.5.18-1ubuntu1.1 \
 libgoogle-glog-dev=0.3.5-1 \
 googletest=1.8.0-6 \
 liblapack-dev=3.7.1-4ubuntu1 \
 liblog4cpp5-dev=1.1.1-3 \
 libmatio-dev=1.5.11-1 \
 libpcap-dev=1.8.1-6ubuntu1 \
 libprotobuf-dev=3.0.0-9.1ubuntu1 \
 protobuf-compiler=3.0.0-9.1ubuntu1 \
 libpugixml-dev=1.8.1-7 \
 libuhd-dev=3.10.3.0-2 \
 git=1:2.17.1-1ubuntu0.4 \
 gnuradio-dev=3.7.11-10 \
 gr-osmosdr=0.1.4-14build1 \
 python-mako=1.0.7+ds1-1 \
 python-six=1.11.0-2 \
 libxml2-dev=2.9.4+dfsg1-6.1ubuntu1.2 \
 bison=2:3.0.4.dfsg-1build1 \
 flex=2.6.4-6 \
 nano=2.9.3-2 \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV APPDATA /root
ENV PYTHONPATH /usr/lib/python2.7/dist-packages
RUN git clone https://github.com/analogdevicesinc/libiio.git && cd libiio && mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/usr .. && NPROC=$(grep -c ^processor /proc/cpuinfo) && make -j$(($NPROC+1)) && make install && cd ../.. && rm -rf *
RUN git clone https://github.com/analogdevicesinc/libad9361-iio.git && cd libad9361-iio && mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/usr .. && NPROC=$(grep -c ^processor /proc/cpuinfo) && make -j$(($NPROC+1)) && make install && cd ../.. && rm -rf *
RUN git clone https://github.com/analogdevicesinc/gr-iio.git && cd gr-iio && mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/usr .. && NPROC=$(grep -c ^processor /proc/cpuinfo) && make -j$(($NPROC+1))  && make install && cd ../.. && rm -rf * && ldconfig
RUN git clone https://github.com/gnss-sdr/gnss-sdr.git && cd gnss-sdr/build && git checkout next && cmake -DENABLE_OSMOSDR=ON -DENABLE_FMCOMMS2=ON -DENABLE_PLUTOSDR=ON -DENABLE_AD9361=ON -DENABLE_RAW_UDP=ON -DENABLE_PACKAGING=ON -DENABLE_INSTALL_TESTS=ON .. && NPROC=$(grep -c ^processor /proc/cpuinfo) && make -j$(($NPROC+1)) && make install && cd ../.. && rm -rf * && rm -rf /home/*
WORKDIR /home
RUN /usr/bin/volk_profile -v 8111
RUN /usr/local/bin/volk_gnsssdr_profile
CMD ["bash"]
