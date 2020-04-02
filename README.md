# ubuntu-chipyard
Vagrant VM configuration for nanoPU Chipyard in Ubuntu 18.04

## Configuration Steps
1. Download l-nic/ubuntu-chipyard (this repository). The host machine does not need a
   full-fledged copy of the chipyard repository or its own git installation.
2. Download and install [Vagrant](https://www.vagrantup.com/downloads.html) and [VirtualBox](https://www.virtualbox.org/wiki/Linux_Downloads) for your host operating system.
   NOTE: may need to run `sudo /sbin/vboxconfig` after installing latest version of VirtualBox.
3. In a terminal, navigate to this repository.
4. Run "vagrant plugin install vagrant-disksize"
4. Run "vagrant up". An Ubuntu 18.04 VM with the RISC-V toolchain, Spike ISA
   simulator, and Verilator cycle-accurate simulator with icenet NIC will
   be automatically provisioned and launched. Expect the final
   installation to consume about 25 to 30 GB.
5. Connect to the vm by typing "vagrant ssh".
6. When you are done, exit the ssh session and run "vagrant halt" to stop the vm.

## Loopback Test Example
1. From your host machine, open a terminal and navigate to the ubuntu-chipyard directory.
2. Run "vagrant up" and then "vagrant ssh" to launch and connect to the VM.
3. From within the VM, run the following:
    $ cd /home/vagrant/chipyard/sims/verilator
    $ ./simulator-example-SimNetworkLNICGPRConfig-debug -v /vagrant/SimNetworkLNICGPRConfig.vcd ../../tests/lnic-cpu-loopback-gpr.riscv
4. Open a new host terminal, navigate to ubuntu-chipyard, and run "vagrant ssh"
5. From within this new VM shell, run:
    $ cd /home/vagrant/chipyard/software/net-app-tester
    $ sudo make loopback
6. The loopback tests should all pass. After the tests complete, ctrl-C the verilator binary.
7. The output file /vagrant/SimNetwrokLNICGPRConfig.vcd contains the simulation waveforms.
   This file may be opened with gtkwave. The /vagrant folder in the VM maps to the ubuntu-chipyard
   directory in the host.

Other nanoPU tests can be found in /home/vagrant/chipyard/tests in the VM. If you wish to modify the tests,
re-run 'make' from the tests directory to rebuild the test binaries.

## Rebuilding nanoPU Chisel Sources
If you modify the nanoPU or underlying rocket-chip Chisel sources, you will need to rebuild the verilator
simulator binary. Run the following:
    $ cd /home/vagrant/chipyard/sims/verilator
    $ make debug CONFIG=SimNetworkLNICGPRConfig TOP=TopWithLNIC -j16



Note: DO NOT run "vagrant destroy" without a good reason. While "vagrant halt"
just shuts down the VM, "vagrant destroy" will delete the VM's virtual hard drive.
