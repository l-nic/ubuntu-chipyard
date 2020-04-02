#!/usr/bin/env bash

# Main Repository Initialization
git clone --branch lnic/sigcomm-20-submission https://github.com/l-nic/chipyard.git
cd chipyard
./scripts/init-submodules-no-riscv-tools.sh
export MAKEFLAGS=-j$(nproc)
./scripts/build-toolchains.sh
echo 'source /home/vagrant/chipyard/env.sh' >> /home/vagrant/.bashrc

# Build the simulator and tests
source /home/vagrant/chipyard/env.sh
cd sims/verilator
make debug CONFIG=SimNetworkLNICGPRConfig TOP=TopWithLNIC -j16
cd /home/vagrant/chipyard/tests
make -j16

# Final Reboot
sudo reboot
