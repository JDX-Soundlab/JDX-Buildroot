#!/bin/bash
rkdeveloptool db rk3399_loader_v1.24.126.bin
rkdeveloptool gpt parameter.txt
rkdeveloptool wl 0x40 idbloader.img
rkdeveloptool wl 0x4000 u-boot.itb
rkdeveloptool wl 0x8000 boot.img
rkdeveloptool wl 0x40000 rootfs.img
rkdeveloptool rd