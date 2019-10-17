# vagrant-firechip
Scripts to bring up a vagrant firechip VM

Configuration steps:
1. Download l-nic/vagrant-firechip (this repository). The host machine does not need a
   full-fledged copy of the firechip repository or its own git installation.
2. Download and install Vagrant for your host operating system.
3. In a terminal, navigate to this repository.
4. Run "vagrant init" and then "vagrant up". An Ubuntu 18.04 VM with the
   RISC-V toolchain, Spike ISA simulator, and Verilator cycle-accurate
   simulator with icenet NIC will be automatically provisioned and launched.
   This will take several hours on the first run, but less than a minute on
   future runs. Expect the final installation to consume about 25 to 30 GB.
5. Connect to the vm by typing "vagrant ssh".
6. When you are done, exit the ssh session and run "vagrant halt" to stop the vm.

Note: DO NOT run "vagrant destroy" without a good reason. While "vagrant halt"
just shuts down the VM, "vagrant destroy" will delete the VM's virtual hard drive,
requiring the entire multi-hour provisioning step to be run again.