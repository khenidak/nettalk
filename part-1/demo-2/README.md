The env prepared for this talk is in fact a routed network.

- The linux bridge where all the VMs are connected is a router
- the host machine is configured to accept `forwarded` packets (packets that has `dst IP != hostIP`)
- How does this work:

### view the forwarding setting on the host:

```
cat /proc/sys/net/ipv4/ip_forward # 1 means forwarding is enabled
```

### view the iptables configuration related to forwarding


```
# routes
ip route | grep demo
# all traffic going to my internal virtual network is routed to my bridge
# 192.168.99.0/24 dev demo-net-br0  proto kernel  scope link  src 192.168.99.1


sudo iptables-save | grep demo # assuming you only have one *demo* bridge
# -A FORWARD -d 192.168.99.0/24 -o demo-net-br0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPTi # con tracking (we will talk about it in part-2
# -A FORWARD -s 192.168.99.0/24 -i demo-net-br0 -j ACCEPT # accept anything forwarded as long as the source is our vm network
# -A FORWARD -i demo-net-br0 -o demo-net-br0 -j ACCEPT # accept forwarding as long it is on the bridge

# snating the entire traffic to outside world (outside the network of the VMs)
sudo iptables-save | grep -F '192.168.99.0/24'

# -A POSTROUTING -s 192.168.99.0/24 ! -d 192.168.99.0/24 -p tcp -j MASQUERADE --to-ports 1024-65535
# -A POSTROUTING -s 192.168.99.0/24 ! -d 192.168.99.0/24 -p udp -j MASQUERADE --to-ports 1024-65535
# -A POSTROUTING -s 192.168.99.0/24 ! -d 192.168.99.0/24 -j MASQUERADE
```

 
