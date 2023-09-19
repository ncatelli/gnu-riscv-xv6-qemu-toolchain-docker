FROM debian:bullseye AS builder
ARG RELEASE_TAG='2023.09.13'
ARG RELEASE_URL="https://github.com/riscv-collab/riscv-gnu-toolchain/releases/download/${RELEASE_TAG}/riscv64-elf-ubuntu-20.04-gcc-nightly-${RELEASE_TAG}-nightly.tar.gz"
ENV RELEASE_URL=${RELEASE_URL}

RUN apt-get update \
    && apt-get install -y curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/

RUN cd /tmp/ \
    && curl -L -o riscv_toolchain.tar.gz ${RELEASE_URL} \
    && tar -zxvf riscv_toolchain.tar.gz \
    && rm riscv_toolchain.tar.gz

FROM debian:bullseye 
LABEL maintainer="Nate Catelli <ncatelli@packetfire.org>"
LABEL description="A wrapper around a riscv toolchain."

ARG UID=1000
ARG GID=1000
ARG USERNAME=dev
ENV USERNAME=${USERNAME}

RUN addgroup --system --gid ${GID} ${USERNAME} \
    && useradd -m -g ${USERNAME} -u ${UID} ${USERNAME}

COPY --from=builder /tmp/riscv /opt/riscv

RUN apt-get update && \
    apt-get install -y make gcc \
    qemu-system-riscv64 \
    libmpc-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/

USER ${USERNAME}

ENV PATH="/opt/riscv/bin:$PATH"

WORKDIR /home/${USERNAME}

CMD ["bash"]
