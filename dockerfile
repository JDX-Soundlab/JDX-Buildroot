FROM ubuntu:24.04
# ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    bash \
    bc \
    binutils \
    build-essential \
    bzip2 \
    cpio \
    device-tree-compiler \
    file \
    findutils \
    g++ \
    gcc \
    genext2fs \
    git \
    gzip \
    locales \
    libncurses-dev \
    libdevmapper-dev \
    libsystemd-dev \
    make \
    mercurial \
    whois \
    patch \
    perl \
    python3 \
    python-is-python3 \
    rsync \
    sed \
    tar \
    vim \ 
    unzip \
    wget \
    gnu-which \
    bison \
    flex \
    libssl-dev \
    libfdt-dev

# Sometimes Buildroot need proper locale, e.g. when using a toolchain
# based on glibc.
RUN locale-gen en_US.utf8

RUN git clone git://git.buildroot.net/buildroot --depth=1 --branch=2025.02 /root/buildroot

WORKDIR /root/buildroot

ENV O=/buildroot_output

VOLUME /buildroot_output
VOLUME /root

COPY .config .config
RUN touch kernel.config
RUN mkdir -p scripts
COPY post.sh scripts/post.sh
RUN mkdir -p kernel-prereq/dts/rockchip
COPY rk-dts/* kernel-prereq/dts/rockchip/
COPY kernel-prereq/* kernel-prereq/
# COPY kernel kernel
COPY rockchip-mali-config.in ./package/rockchip-mali/Config.in

# RUN git init /root/buildroot/kernel/.git

VOLUME /root/buildroot/package
VOLUME /root/buildroot/dl
VOLUME /buildroot_output

RUN make toolchain
# RUN make source
# RUN make linux

# Create kernel packing tree
RUN mkdir -p kernel-pack/boot/extlinux
COPY extlinux.conf kernel-pack/boot/extlinux
RUN ln -s output/images/Image kernel-pack/boot/Image
RUN ln -s kernel-prereq/dts/rockchip/rk3399-firefly-aio-lvds.dtb kernel-pack/boot/rk3399-firefly-aio-lvds.dtb

# RUN dtc -I dts -O dtb -o ./kernel-prereq/rk3399-firefly-aio-lvds.dtb ./kernel-prereq/dts/rockchip/rk3399-firefly-aio-lvds.dts

RUN ["/bin/bash"]
CMD ["/bin/bash"]
