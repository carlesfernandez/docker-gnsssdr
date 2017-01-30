FROM phusion/baseimage:0.9.19
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
    libboost-program-options-dev \
    libboost-system-dev \
    libboost-test-dev \
    libboost-thread-dev \
    libgflags-dev \
    libgnutls-openssl-dev \
    libgoogle-glog-dev \
    libgtest-dev \
    liblapack-dev \
    liblog4cpp5-dev \
    libuhd-dev \
    git \
    gnuradio-dev \
    gr-osmosdr \
    python-mako \
    python-six \
 && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/gnss-sdr/gnss-sdr.git
RUN cd gnss-sdr/build && git checkout next && cmake -DENABLE_OSMOSDR=ON -DENABLE_PACKAGING=ON .. && make && make install
RUN /usr/bin/volk_profile
RUN /usr/local/bin/volk_gnsssdr_profile
RUN apt-get clean && rm -rf /tmp/* /var/tmp/*
