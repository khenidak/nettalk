
## What is this?
Stands up a demo env of 3 VMs (ubuntu 18.04 TLS) on a bridge with pre assigned IPs.


## How can i use it?

### pre-req
I use azure nested VMs, with KVM, virsh-install, and virsh installed. A VM or a physical box with those should allow you to run the demo 

### Bootstrap
```
cd env
./setup.sh
```

IPs are 
```
<host mac='52:54:00:4c:40:1c' name='demo-vm1' ip='192.168.99.10'/>
<host mac='52:54:00:4c:40:12' name='demo-vm1' ip='192.168.99.20'/>
<host mac='52:54:00:4c:40:13' name='demo-vm1' ip='192.168.99.30'/>
```

network is nat-ed with cidr `192.168.99.2/24`, you won't be able to ingress traffic into it outside the host.

### Teardown

```
cd env
./teardown.sh
```


### FAQ

#### do i have to be in `env` dir?
yes, i never run it otherwise, even when it is safe to do so

#### can i change the configuration of the machine?
for s/w edit `./env/demo-vm{idx}.seed` to add more packages, the VMs are based on ubuntu cloud images.
for h/w edit `setup.sh::start_vms()` function


#### I want to add more machine, what now?

1. if you want to assign a static ip, then edit network.xml (you will need to tear down the network and recreate it)
2. add a seed file
3. change counters in `setup.sh` and `teardown.sh`
