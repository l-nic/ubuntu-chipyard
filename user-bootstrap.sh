#!/usr/bin/env bash

export RISCV=/opt/riscv
export PATH=$RISCV/bin:$PATH

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

# Final Reboot
sudo reboot
