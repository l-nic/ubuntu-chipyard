#!/usr/bin/env bash

# Dependency and Path Configuration
apt-get update
apt-get upgrade
mkdir /opt/riscv
chown -R $USER /opt/riscv
echo "export RISCV=/opt/riscv" >> ~/.bashrc
echo "export PATH=$RISCV/bin:$PATH" >> ~/.bashrc
source ~/.bashrc
echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
apt-get update
apt-get install autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev -y
apt-get install libusb-1.0-0-dev gawk build-essential bison flex texinfo gperf libtool -y
apt-get install patchutils bc zlib1g-dev device-tree-compiler pkg-config libexpat-dev -y
apt-get install git python default-jdk libssl-dev net-tools -y
apt-get install sbt -y

# Simulator Network Interface Configuration
sudo touch /usr/local/bin/start-tap-devices.sh
sudo chown -R $USER /usr/local/bin/start-tap-devices.sh
echo "sudo ip tuntap add mode tap dev tap0 user $USER" >> /usr/local/bin/start-tap-devices.sh
echo "sudo ip link set tap0 up" >> /usr/local/bin/start-tap-devices.sh
echo "sudo ip addr add 192.168.1.1/24 dev tap0" >> /usr/local/bin/start-tap-devices.sh
echo "@reboot /usr/local/bin/start-tap-devices.sh" | crontab -
/usr/local/bin/start-tap-devices.sh

# Main Repository Initialization
git clone https://github.com/l-nic/firechip.git
cd firechip
git submodule update --init --recursive --progress
patch ~/firechip/icenet/csrc/SimNetwork.cc /vagrant/SimNetwork.patch

# RISC-V Toolchain and Spike (ISA) Simulator Compilation
cd ~/firechip/riscv-tools
./build.sh -j$(nproc)

# Verilator (Cycle-Accurate) Simulator Compilation
cd ~/firechip/verisim
make -j$(nproc)
make -j$(nproc) # Yes, we have to run make twice
make -j$(nproc) CONFIG=SimNetworkConfig
cd ~/firechip/tests
make -j$(nproc)
