#!/bin/bash
rkdeveloptool db rk3399_loader_v1.24.126.bin #loader
rkdeveloptool gpt parameter.txt #gpt
rkdeveloptool wl 0x40 images/idbloader.img #idbloader
rkdeveloptool wl 0x4000 images/u-boot.itb #uboot
rkdeveloptool wl 0x8000 images/Image #kernel
rkdeveloptool wl 0x40000 images/rootfs.ext2 #rootfs
rkdeveloptool rd 