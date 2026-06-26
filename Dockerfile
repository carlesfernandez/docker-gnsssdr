# SPDX-FileCopyrightText: 2017-2026, Carles Fernandez-Prades <carles.fernandez@cttc.es>
# SPDX-License-Identifier: MIT
#
# Use phusion/baseimage as base image.
# See https://github.com/phusion/baseimage-docker/releases
# for a list of version numbers.

FROM phusion/baseimage:resolute
LABEL version="7.0" description="GNSS-SDR image" maintainer="carles.fernandez@cttc.es"

WORKDIR /home/src

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
  bison=2:3.8.2+dfsg-1build4 \
  build-essential=12.12ubuntu2.26.04.1 \
  cmake=4.2.3-2ubuntu2 \
  flex=2.6.4-8.2build2 \
  gir1.2-gtk-3.0=3.24.52-0ubuntu1 \
  git=1:2.53.0-1ubuntu1 \
  gnuradio-dev=3.10.12.0-6 \
  gr-osmosdr=0.2.6-6 \
  libabsl-dev=20260107.0-4 \
  libad9361-dev=0.3-4 \
  libarmadillo-dev=1:15.2.1+dfsg-2 \
  libblas-dev=3.12.1-7ubuntu1 \
  libboost-chrono-dev=1.90.0.1ubuntu3 \
  libboost-date-time-dev=1.90.0.1ubuntu3 \
  libboost-dev=1.90.0.1ubuntu3 \
  libboost-serialization-dev=1.90.0.1ubuntu3 \
  libboost-thread-dev=1.90.0.1ubuntu3 \
  libgtest-dev=1.17.0-1build1 \
  libiio-dev=0.26-2build2 \
  liblapack-dev=3.12.1-7ubuntu1 \
  libmatio-dev=1.5.30-2 \
  liborc-0.4-dev=1:0.4.42-2 \
  libpcap-dev=1.10.6-1ubuntu1 \
  libprotobuf-dev=3.21.12-15ubuntu1 \
  libpugixml-dev=1.14-2build1 \
  libssl-dev=3.5.5-1ubuntu3.2 \
  libuhd-dev=4.9.0.1-1ubuntu1 \
  libxml2-dev=2.15.2+dfsg-0.1ubuntu0.1 \
  nano=8.7.1-1ubuntu0.1 \
  protobuf-compiler=3.21.12-15ubuntu1 \
  python3-mako=1.3.10-3ubuntu0.1 \
  vim=2:9.1.2141-1ubuntu4.5 \
  && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV APPDATA=/root
ENV PYTHONPATH=/usr/lib/python3/dist-packages

ARG GITHUB_USER=gnss-sdr
ARG GITHUB_REPO=gnss-sdr
ARG GITHUB_BRANCH=next

RUN git config --global http.postBuffer 52428800 && \
  git clone https://github.com/${GITHUB_USER}/${GITHUB_REPO}.git && \
  cd gnss-sdr  && git checkout ${GITHUB_BRANCH} && mkdir -p build && cd build && \
  cmake -DENABLE_OSMOSDR=ON -DENABLE_FMCOMMS2=ON -DENABLE_PLUTOSDR=ON -DENABLE_RAW_UDP=ON -DENABLE_ZMQ=ON -DENABLE_ION=ON -DENABLE_PACKAGING=ON -DENABLE_INSTALL_TESTS=ON .. && \
  make -j2 && make install && cd ../.. && rm -rf * && rm -rf /home/*

WORKDIR /home
RUN /usr/bin/volk_profile -v 8111
RUN /usr/local/bin/volk_gnsssdr_profile
CMD ["bash"]