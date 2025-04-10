# SPDX-FileCopyrightText: 2017-2025, Carles Fernandez-Prades <carles.fernandez@cttc.es>
# SPDX-License-Identifier: MIT
#
# Use phusion/baseimage as base image.
# See https://github.com/phusion/baseimage-docker/releases
# for a list of version numbers.

FROM phusion/baseimage:noble-1.0.2
LABEL version="6.0" description="GNSS-SDR image" maintainer="carles.fernandez@cttc.es"

WORKDIR /home/src

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
  bison=2:3.8.2+dfsg-1build2 \
  build-essential=12.10ubuntu1 \
  cmake=3.28.3-1build7 \
  flex=2.6.4-8.2build1 \
  gir1.2-gtk-3.0=3.24.41-4ubuntu1.2 \
  git=1:2.43.0-1ubuntu7.2 \
  gnuradio-dev=3.10.9.2-1.1ubuntu2 \
  gr-osmosdr=0.2.5-2.1build3 \
  libad9361-dev=0.3-2build1 \
  libarmadillo-dev=1:12.6.7+dfsg-1build2 \
  libblas-dev=3.12.0-3build1.1 \
  libboost-chrono-dev=1.83.0.1ubuntu2 \
  libboost-date-time-dev=1.83.0.1ubuntu2 \
  libboost-dev=1.83.0.1ubuntu2 \
  libboost-serialization-dev=1.83.0.1ubuntu2 \
  libboost-system-dev=1.83.0.1ubuntu2 \
  libboost-thread-dev=1.83.0.1ubuntu2 \
  libgflags-dev=2.2.2-2build1 \
  libgnutls28-dev=3.8.3-1.1ubuntu3.3 \
  libgoogle-glog-dev=0.6.0-2.1build1 \
  libgtest-dev=1.14.0-1 \
  libiio-dev=0.25-4build2 \
  liblapack-dev=3.12.0-3build1.1 \
  libmatio-dev=1.5.26-1build3 \
  libsndfile1-dev=1.2.2-1ubuntu5.24.04.1 \
  liborc-0.4-dev=1:0.4.38-1ubuntu0.1 \
  libpcap-dev=1.10.4-4.1ubuntu3 \
  libprotobuf-dev=3.21.12-8.2build1 \
  libpugixml-dev=1.14-0.1build1 \
  libuhd-dev=4.6.0.0+ds1-5.1ubuntu0.24.04.1 \
  libxml2-dev=2.9.14+dfsg-1.3ubuntu3.2 \
  nano=7.2-2ubuntu0.1 \
  protobuf-compiler=3.21.12-8.2build1 \
  python3-mako=1.3.2-1 \
  vim=2:9.1.0016-1ubuntu7.8 \
  && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV APPDATA=/root
ENV PYTHONPATH=/usr/lib/python3/dist-packages

ARG GITHUB_USER=gnss-sdr
ARG GITHUB_REPO=gnss-sdr
ARG GITHUB_BRANCH=next

RUN git config --global http.postBuffer 52428800 && \
  git clone https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git && \
  cd gnss-sdr  && git checkout ${GITHUB_BRANCH} && mkdir -p build && cd build && \
  cmake -DENABLE_OSMOSDR=ON -DENABLE_FMCOMMS2=ON -DENABLE_PLUTOSDR=ON -DENABLE_RAW_UDP=ON -DENABLE_ZMQ=ON -DENABLE_PACKAGING=ON -DENABLE_INSTALL_TESTS=ON .. && \
  make -j2 && make install && cd ../.. && rm -rf * && rm -rf /home/*

WORKDIR /home
RUN /usr/bin/volk_profile -v 8111
RUN /usr/local/bin/volk_gnsssdr_profile
CMD ["bash"]
