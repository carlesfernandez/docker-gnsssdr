# SPDX-FileCopyrightText: 2017-2021, Carles Fernandez-Prades <carles.fernandez@cttc.es>
# SPDX-License-Identifier: MIT
#
# Use phusion/baseimage as base image.
# See https://github.com/phusion/baseimage-docker/releases
# for a list of version numbers.

FROM phusion/baseimage:focal-1.0.0
LABEL version="2.0" description="GNSS-SDR image" maintainer="carles.fernandez@cttc.es"

WORKDIR /home/src

RUN apt-get update && apt-get install -y --no-install-recommends \
 bison=2:3.5.1+dfsg-1 \
 build-essential=12.8ubuntu1.1 \
 cmake=3.16.3-1ubuntu1 \
 flex=2.6.4-6.2 \
 gir1.2-gtk-3.0=3.24.20-0ubuntu1 \
 git=1:2.25.1-1ubuntu3.2 \
 gnuradio-dev=3.8.1.0~rc1-2build2 \
 gr-iio=0.3-7build3 \
 gr-osmosdr=0.2.0-2 \
 libad9361-dev=0.2-1 \
 libarmadillo-dev=1:9.800.4+dfsg-1build1 \
 libblas-dev=3.9.0-1build1 \
 libboost-chrono-dev=1.71.0.0ubuntu2 \
 libboost-date-time-dev=1.71.0.0ubuntu2 \
 libboost-dev=1.71.0.0ubuntu2 \
 libboost-serialization-dev=1.71.0.0ubuntu2 \
 libboost-system-dev=1.71.0.0ubuntu2 \
 libboost-thread-dev=1.71.0.0ubuntu2 \
 libgflags-dev=2.2.2-1build1 \
 libgnutls28-dev=3.6.13-2ubuntu1.6 \
 libgoogle-glog-dev=0.4.0-1build1 \
 libgtest-dev=1.10.0-2 \
 libiio-dev=0.19-1 \
 liblapack-dev=3.9.0-1build1 \
 liblog4cpp5-dev=1.1.3-1ubuntu1 \
 libmatio-dev=1.5.17-3 \
 liborc-0.4-dev=1:0.4.31-1 \
 libpcap-dev=1.9.1-3 \
 libprotobuf-dev=3.6.1.3-2ubuntu5 \
 libpugixml-dev=1.10-1 \
 libuhd-dev=3.15.0.0-2build5 \
 libxml2-dev=2.9.10+dfsg-5 \
 nano=4.8-1ubuntu1 \
 protobuf-compiler=3.6.1.3-2ubuntu5 \
 python3-mako=1.1.0+ds1-1ubuntu2 \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV APPDATA /root
ENV PYTHONPATH /usr/lib/python3/dist-packages

ARG GITHUB_USER=gnss-sdr
ARG GITHUB_REPO=gnss-sdr
ARG GITHUB_BRANCH=next

RUN git clone https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git && \
  cd gnss-sdr/build && git checkout ${GITHUB_BRANCH} && \
  cmake -DENABLE_OSMOSDR=ON -DENABLE_FMCOMMS2=ON -DENABLE_PLUTOSDR=ON -DENABLE_AD9361=ON -DENABLE_RAW_UDP=ON -DENABLE_PACKAGING=ON -DENABLE_INSTALL_TESTS=ON .. && \
  make -j2 && make install && cd ../.. && rm -rf * && rm -rf /home/*

WORKDIR /home
RUN /usr/bin/volk_profile -v 8111
RUN /usr/local/bin/volk_gnsssdr_profile
CMD ["bash"]
