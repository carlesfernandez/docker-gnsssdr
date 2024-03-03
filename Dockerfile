# SPDX-FileCopyrightText: 2017-2024, Carles Fernandez-Prades <carles.fernandez@cttc.es>
# SPDX-License-Identifier: MIT
#
# Use phusion/baseimage as base image.
# See https://github.com/phusion/baseimage-docker/releases
# for a list of version numbers.

FROM phusion/baseimage:jammy-1.0.2
LABEL version="4.0" description="GNSS-SDR image" maintainer="carles.fernandez@cttc.es"

WORKDIR /home/src

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get install -y --no-install-recommends \
  bison=2:3.8.2+dfsg-1build1 \
  build-essential=12.9ubuntu3 \
  cmake=3.22.1-1ubuntu1.22.04.2 \
  flex=2.6.4-8build2 \
  gir1.2-gtk-3.0=3.24.33-1ubuntu1 \
  git=1:2.34.1-1ubuntu1.9 \
  gnuradio-dev=3.10.1.1-2 \
  gr-osmosdr=0.2.3-5build2 \
  libad9361-dev=0.2-1 \
  libarmadillo-dev=1:10.8.2+dfsg-1 \
  libblas-dev=3.10.0-2ubuntu1 \
  libboost-chrono-dev=1.74.0.3ubuntu7 \
  libboost-date-time-dev=1.74.0.3ubuntu7 \
  libboost-dev=1.74.0.3ubuntu7 \
  libboost-serialization-dev=1.74.0.3ubuntu7 \
  libboost-system-dev=1.74.0.3ubuntu7 \
  libboost-thread-dev=1.74.0.3ubuntu7 \
  libgflags-dev=2.2.2-2 \
  libgnutls28-dev=3.7.3-4ubuntu1.4 \
  libgoogle-glog-dev=0.5.0+really0.4.0-2 \
  libgtest-dev=1.11.0-3 \
  libiio-dev=0.23-2 \
  liblapack-dev=3.10.0-2ubuntu1 \
  libmatio-dev=1.5.21-1 \
  libsndfile1-dev=1.0.31-2ubuntu0.1 \
  liborc-0.4-dev=1:0.4.32-2 \
  libpcap-dev=1.10.1-4build1 \
  libprotobuf-dev=3.12.4-1ubuntu7.22.04.1 \
  libpugixml-dev=1.12.1-1 \
  libuhd-dev=4.1.0.5-3 \
  libxml2-dev=2.9.13+dfsg-1ubuntu0.4 \
  nano=6.2-1 \
  protobuf-compiler=3.12.4-1ubuntu7.22.04.1 \
  python3-mako=1.1.3+ds1-2 \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV APPDATA /root
ENV PYTHONPATH /usr/lib/python3/dist-packages

ARG GITHUB_USER=gnss-sdr
ARG GITHUB_REPO=gnss-sdr
ARG GITHUB_BRANCH=next

RUN git config --global http.postBuffer 52428800 && \
  git clone https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git && \
  cd gnss-sdr/build && git checkout ${GITHUB_BRANCH} && \
  cmake -DENABLE_OSMOSDR=ON -DENABLE_FMCOMMS2=ON -DENABLE_PLUTOSDR=ON -DENABLE_AD9361=ON -DENABLE_RAW_UDP=ON -DENABLE_ZMQ=ON -DENABLE_PACKAGING=ON -DENABLE_INSTALL_TESTS=ON .. && \
  make -j2 && make install && cd ../.. && rm -rf * && rm -rf /home/*

WORKDIR /home
RUN /usr/bin/volk_profile -v 8111
RUN /usr/local/bin/volk_gnsssdr_profile
CMD ["bash"]
