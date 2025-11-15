#FROM uxora/linux-kvm:oracular
FROM qemux/qemu:latest
LABEL maintainer="Michel VONGVILAY <https://www.uxora.com/about/me#contact-form>"
LABEL version="0.93"

RUN set -eu && \
    apt-get update && \
    apt-get --no-install-recommends -y install \
        bc \
        file \
        bridge-utils \
        jq \
        curl \
        7zip \
        xz-utils \
        wimtools \
        dos2unix \
        cabextract \
        genisoimage \
        libxml2-utils \
        libarchive-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV SCRIPT_VERSION="0.93"

# Resources
ENV CPU="qemu64"
ENV THREADS="1"
ENV CORES="1"
ENV RAM="2048"

# Bootloader
ENV BOOTLOADER_URL=""
ENV BOOTLOADER_AS_USB="Y"
ENV BOOTLOADER_FORCE_REPLACE="N"
ENV BOOTLOADER_ALT_PATH="/xpy/bootloader/bootloader.img"

# Disk
ENV DISK_SIZE="32"
ENV DISK_FORMAT="qcow2"
ENV DISK_OPTS_DRV="cache=writeback,discard=on,aio=threads,detect-zeroes=unmap"
ENV DISK_OPTS_DEV="rotation_rate=1"
ENV DISK_PATH="/xpy/diskvm"

# Network
ENV VM_NET_IP="20.20.20.21"
ENV VM_NET_MAC="00:11:32:2C:A7:85"
ENV VM_NET_DHCP="N"

# Options
ENV VM_ENABLE_VGA="Y"
ENV VM_ENABLE_VIRTIO="Y"
ENV VM_ENABLE_VIRTIO_SCSI="N"
ENV VM_ENABLE_9P="Y"
ENV VM_9P_PATH="/xpy/share9p"
ENV VM_9P_OPTS="local,security_model=passthrough"
ENV VM_CUSTOM_OPTS=""

ENV VM_TIMEOUT_POWERDOWN="30"

# GRUB CFG
ENV GRUBCFG_ENABLE_MOD="N"
ENV GRUBCFG_VID=""
ENV GRUBCFG_PID=""
ENV GRUBCFG_SN=""
ENV GRUBCFG_DISKIDXMAP=""
ENV GRUBCFG_SATAPORTMAP=""
ENV GRUBCFG_SASIDXMAP=""
ENV GRUBCFG_HDDHOTPLUG=""

VOLUME ${DISK_PATH}
VOLUME /xpy/bootloader
VOLUME /xpy/share9p

ENTRYPOINT ["/usr/bin/vm-startup", "start"]

COPY bin cfg /qemu_cfg/

RUN chmod -R +x /qemu_cfg/vm-* \
    && mv /qemu_cfg/vm-* /usr/bin/. \
    && echo "INF: shell scripts have been successfully copied to /usr/bin" \
    || ( echo "ERR: Something went wrong with shell scripts!" && exit 255 )