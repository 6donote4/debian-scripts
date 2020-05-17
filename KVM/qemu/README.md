How to connect to  virtual router by bridge?

1. Create a bridge by using NetworkManager
    a. set ipv4 manully and iput a LAN address (ex:192.168.3.1/24, gateway:none)
    b. disable ipv6
    c. add a veth interface ,set a physical interface to device.

2. Important: stop Zerotier or docker (virtual network,they will polute your ARP table)
