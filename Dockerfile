FROM archlinux:latest

# Update all packages and install ESP-IDF dependencies
RUN pacman -Syu --noconfirm && \
    pacman -S gcc git make flex bison gperf python-pip cmake ninja ccache dfu-util which rsync sshpass --noconfirm

# Change to the same user and home directory as the Raspberry Pi
RUN useradd -m alarm
USER alarm
WORKDIR /home/alarm/

# Pull down and install the ESP-IDF toolchain
RUN git clone --recursive --depth 1 --branch v4.3-dev https://github.com/espressif/esp-idf.git && \
    sed -i 's/gdbgui>=/gdbgui==/g' /home/alarm/esp-idf/requirements.txt && \
    /home/alarm/esp-idf/install.sh

# Tweak some SSH settings
RUN mkdir .ssh
COPY config .ssh/

# Copy over the remote upload shim and patch the file that calls it
COPY run_remote_cmd.cmake /home/alarm/esp-idf/components/esptool_py/
RUN sed -i 's/run_cmd/run_remote_cmd/g' /home/alarm/esp-idf/components/esptool_py/run_esptool.cmake

# Copy over the monitor shim in place of the proper Python script
COPY idf_monitor.py /home/alarm/esp-idf/tools/

# Source ESP-IDF on login
CMD source /home/alarm/esp-idf/export.sh && bash
