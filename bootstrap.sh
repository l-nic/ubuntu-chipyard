#!/usr/bin/env bash

# Dependency and Path Configuration
apt-get update
apt-get upgrade
mkdir /opt/riscv
chown -R $USER /opt/riscv
echo 'export RISCV=/opt/riscv' >> /home/vagrant/.bashrc
echo 'export PATH=$RISCV/bin:$PATH' >> /home/vagrant/.bashrc
export RISCV=/opt/riscv
export PATH=$RISCV/bin:$PATH
echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
apt-get update
apt-get install autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev -y
apt-get install libusb-1.0-0-dev gawk build-essential bison flex texinfo gperf libtool -y
apt-get install patchutils bc zlib1g-dev device-tree-compiler pkg-config libexpat-dev -y
apt-get install git python default-jdk libssl-dev net-tools -y
apt-get install sbt -y
apt-get install python-pip
pip install future

# Simulator Network Interface Configuration
sudo touch /usr/local/bin/start-tap-devices.sh
sudo chown $USER /usr/local/bin/start-tap-devices.sh
echo "sudo ip tuntap add mode tap dev tap0 user vagrant" >> /usr/local/bin/start-tap-devices.sh
echo "sudo ip link set tap0 up" >> /usr/local/bin/start-tap-devices.sh
echo "sudo ip addr add 192.168.1.1/24 dev tap0" >> /usr/local/bin/start-tap-devices.sh
echo "@reboot /usr/local/bin/start-tap-devices.sh" | sudo crontab -u vagrant -

# Main Repository Initialization
git clone --branch lnic-dev https://github.com/l-nic/firechip.git
cd firechip
git submodule update --init --recursive --progress
patch /home/vagrant/firechip/icenet/csrc/SimNetwork.cc /vagrant/SimNetwork.patch

# RISC-V Toolchain and Spike (ISA) Simulator Compilation
cd /home/vagrant/firechip/riscv-tools
./build.sh -j$(nproc)

# Verilator (Cycle-Accurate) Simulator Compilation
cd /home/vagrant/firechip/verisim
make -j$(nproc)
make -j$(nproc) # Yes, we have to run make twice
make -j$(nproc) CONFIG=SimNetworkConfig
cd /home/vagrant/firechip/tests
make -j$(nproc)

# Final Permissions Changes and Reboot
# TODO: Might be able to get rid of these permissions changes
sudo chown vagrant /usr/local/bin/start-tap-devices.sh
sudo chmod +x /usr/local/bin/start-tap-devices.sh
sudo chown -R vagrant /opt/riscv
sudo chown -R vagrant /home/vagrant/firechip
sudo reboot
