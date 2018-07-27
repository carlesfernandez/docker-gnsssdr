FROM phusion/baseimage:0.10.1
MAINTAINER carles.fernandez@cttc.es

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

WORKDIR /home/src

RUN apt-get update && apt-get install -y \
    build-essential=12.1ubuntu2 \
    cmake=3.5.1-1ubuntu3 \
    libarmadillo-dev=1:6.500.5+dfsg-1 \
    libblas-dev=3.6.0-2ubuntu2 \
    libboost-chrono-dev=1.58.0.1ubuntu1 \
    libboost-dev=1.58.0.1ubuntu1 \
    libboost-date-time-dev=1.58.0.1ubuntu1 \
    libboost-filesystem-dev=1.58.0.1ubuntu1 \
    libboost-serialization-dev=1.58.0.1ubuntu1 \
    libboost-system-dev=1.58.0.1ubuntu1 \
    libboost-thread-dev=1.58.0.1ubuntu1 \
    libgflags-dev=2.1.2-3 \
    libgnutls-dev=3.4.10-4ubuntu1.4 \
    libgoogle-glog-dev=0.3.4-0.1 \
    libgtest-dev=1.7.0-4ubuntu1 \
    liblapack-dev=3.6.0-2ubuntu2 \
    liblog4cpp5-dev=1.0-4.1 \
    libmatio-dev=1.5.3-1 \
    libpcap-dev=1.7.4-2 \
    libuhd-dev=3.9.2-1 \
    git=1:2.7.4-0ubuntu1.4 \
    gnuradio-dev=3.7.9.1-2ubuntu1 \
    gr-osmosdr=0.1.4-8 \
    python-mako=1.0.3+ds1-1ubuntu1 \
    python-six=1.10.0-3 \
    libxml2-dev=2.9.3+dfsg1-1ubuntu0.5 \
    bison=2:3.0.4.dfsg-1 \
    flex=2.6.0-11 \
    nano=2.5.3-2ubuntu2 \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV APPDATA /root
RUN git clone https://github.com/analogdevicesinc/libiio.git && cd libiio && mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/usr .. && make && make install && cd .. && rm -rf *
RUN cd ..
RUN git clone https://github.com/analogdevicesinc/libad9361-iio.git
RUN cd libad9361-iio && mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/usr .. && make && make install && cd .. && rm -rf *
RUN cd ..
RUN git clone https://github.com/analogdevicesinc/gr-iio.git
RUN cd gr-iio && mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/usr .. && make && make install && cd .. && rm -rf *
RUN cd ..
RUN ldconfig
RUN git clone https://github.com/gnss-sdr/gnss-sdr.git && cd gnss-sdr/build && git checkout next && cmake -DENABLE_OSMOSDR=ON -DENABLE_FMCOMMS2=ON -DENABLE_PLUTOSDR=ON -DENABLE_AD9361=ON -DENABLE_RAW_UDP=ON -DENABLE_PACKAGING=ON -DENABLE_INSTALL_TESTS=ON .. && make && make install && cd .. && rm -rf *
RUN /usr/bin/volk_profile -v 8111
RUN /usr/local/bin/volk_gnsssdr_profile
RUN apt-get clean && rm -rf /tmp/* /var/tmp/*
RUN rm -rf /home/src
WORKDIR /home
CMD ["bash"]
