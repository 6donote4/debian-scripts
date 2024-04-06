1. install netctl:
```
sudo pacman -S netctl
sudo apt-get install netctl

```

2. mv the network configuration file and change them:
```
cp bridge0 wifi /etc/netctl 

```

3. enable network profile and start them:
```
netctl enable bridge0 wifi
netctl start bridge0 wifi
```

4. repaire the bridge network
change the net_id for ip address
