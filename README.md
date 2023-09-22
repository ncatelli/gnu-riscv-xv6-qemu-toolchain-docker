# gnu-riscv-toolchain-docker

## Description

A container for building and running [xv6-riscv](https://github.com/mit-pdos/xv6-riscv). For more information visit the [csail course page](https://pdos.csail.mit.edu/6.1810/2023/)

## Building
Building the latest `2023.09.13` release from source can be best done using buildkit with the following command

```bash
docker buildx build --build-arg 'RELEASE_TAG=2023.09.13' --build-arg 'CONFIGURE_FLAGS=--enable-multilib' --build-arg 'MAKE_FLAGS=-j4' -t gnu-riscv-newlib-toolchain:2023.09.13 -f Dockerfile.source-build .
```

## Running
```bash
git clone git@github.com:ncatelli/xv6-riscv.git
cd xv6-riscv
docker run -it --rm -v $PWD:/build -w /build ghcr.io/ncatelli/gnu-riscv-xv6-qemu-toolchain-docker:2023.09.13 make qemu
```
