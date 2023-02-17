FROM osrf/ros:humble-desktop AS test
LABEL maintainer="Leonard Jung <jung340@purdue.edu>"

ENV ROS_DISTRO humble
ENV GAZEBO_VER garden

RUN mkdir /root/workspace /root/workspace/src /root/workspace/src/package

RUN apt-get update && apt-get install --quiet -y \
    ros-$ROS_DISTRO-mavros \
    ros-$ROS_DISTRO-mavros-extras \
    ament-cmake \
    bc \
    cmake \
    wget \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-ugly \
    libeigen3-dev \
    libgstreamer-plugins-base1.0-dev \
    libopencv-dev \
    protobuf-compiler \
    python3-jsonschema \
    python3-numpy \
    python3-pip \
    unzip && \
    apt-get -y autoremove && \
    apt-get clean autoclean && \
    rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

RUN pip3 install --upgrade pip && \
    pip3 install empy \
                 future \
                 jinja2 \
                 kconfiglib \
                 packaging \
                 pyros-genmsg \
                 toml \
                 pyyaml

COPY install/docker_clean.sh /docker_clean.sh
COPY install/install_geolib_datasets.sh /tmp/install/install_geolib_datasets.sh
COPY install/install_gz.sh /tmp/install/install_gz.sh
RUN chmod +x /docker_clean.sh /tmp/install/install_geolib_datasets.sh /tmp/install/install_gz.sh
RUN sudo /tmp/install/install_geolib_datasets.sh && /tmp/install/install_gz.sh && /docker_clean.sh 

RUN git clone https://github.com/PX4/PX4-Autopilot.git /PX4-Autopilot
RUN git -C /PX4-Autopilot checkout main
RUN git -C /PX4-Autopilot submodule update --init --recursive

WORKDIR /root/workspace
