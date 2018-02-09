FROM phusion/baseimage:0.10.0
MAINTAINER carles.fernandez@cttc.es

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

WORKDIR /home/src

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libarmadillo-dev \
    libblas-dev \
    libboost-chrono-dev \
    libboost-dev \
    libboost-date-time-dev \
    libboost-filesystem-dev \
    libboost-serialization-dev \
    libboost-system-dev \
    libboost-thread-dev \
    libgflags-dev \
    libgnutls-openssl-dev \
    libgoogle-glog-dev \
    libgtest-dev \
    liblapack-dev \
    liblog4cpp5-dev \
    libmatio-dev \
    libuhd-dev \
    git \
    gnuradio-dev \
    gr-osmosdr \
    python-mako \
    python-six \
    libxml2-dev \
    bison \
    flex \
 && rm -rf /var/lib/apt/lists/*

ENV APPDATA /root
RUN git clone https://github.com/analogdevicesinc/libiio.git
RUN cd libiio && mkdir build && cd build && cmake .. && make && make install
RUN cd ../..
RUN git clone https://github.com/analogdevicesinc/libad9361-iio.git
RUN cd libad9361-iio && mkdir build && cd build && cmake .. && make && make install
RUN cd ../..
RUN git clone https://github.com/analogdevicesinc/gr-iio.git
RUN cd gr-iio && mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/usr .. && make && make install
RUN cd ../..
RUN git clone https://github.com/gnss-sdr/gnss-sdr.git
RUN cd gnss-sdr/build && git checkout next && cmake -DENABLE_OSMOSDR=ON -DENABLE_FMCOMMS2=ON -DENABLE_PLUTOSDR=ON -DENABLE_PACKAGING=ON .. && make && make install
RUN /usr/bin/volk_profile
RUN /usr/local/bin/volk_gnsssdr_profile
RUN apt-get clean && rm -rf /tmp/* /var/tmp/*
RUN rm -rf /home/src
WORKDIR /home
CMD ["bash"]
