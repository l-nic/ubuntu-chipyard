#!/usr/bin/env bash

# Dependency and Path Configuration
apt-get update
apt-get upgrade
mkdir /opt/riscv
chown -R vagrant /opt/riscv
echo 'export RISCV=/opt/riscv' >> /home/vagrant/.bashrc
echo 'export PATH=$RISCV/bin:$PATH' >> /home/vagrant/.bashrc
echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
apt-get update
apt-get install autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev -y
apt-get install libusb-1.0-0-dev gawk build-essential bison flex texinfo gperf libtool -y
apt-get install patchutils bc zlib1g-dev device-tree-compiler pkg-config libexpat-dev -y
apt-get install git python default-jdk libssl-dev net-tools -y
apt-get install sbt -y
apt-get install python-pip -y
pip install future
apt-get install libglib2.0-dev -y
apt-get install libpixman-1-dev -y


# Simulator Network Interface Configuration
touch /usr/local/bin/start-tap-devices.sh
chown vagrant /usr/local/bin/start-tap-devices.sh
echo "sudo ip tuntap add mode tap dev tap0 user vagrant" >> /usr/local/bin/start-tap-devices.sh
echo "sudo ip link set tap0 up" >> /usr/local/bin/start-tap-devices.sh
echo "sudo ip addr add 192.168.1.1/24 dev tap0" >> /usr/local/bin/start-tap-devices.sh
chmod +x /usr/local/bin/start-tap-devices.sh
echo "@reboot /usr/local/bin/start-tap-devices.sh" | sudo crontab -u vagrant -

