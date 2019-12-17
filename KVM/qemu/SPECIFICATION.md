# OpenWRT 虚拟机路由系统搭建说明
1. 安装必备的软件包
apt-get install libvirt qemu brctl -y
pacman -S libivrt qemu
2.配置网络环境
* ARCH:使用NetworkManager创建桥接接口br0(wan),br1(lan),
向br0添加连接外网的接口,若是无线网卡,可先创建一vlan隧道,在vlan上添加无线网卡接口,再把vlan添加到br0,
* br1直接添加内网以太接口.
* Debian:需配置interface文件,也可使用NetworkManager进行配置
* 给连接外网的桥接网口br0设置DHCP客户端,添加域名解析,给内网桥接接口静态地址及子网掩码,设置dns.
3.配置防火墙转发规则，设置内核参数允许转发
内核参数设置
`echo "1">/proc/sys/net/ipv4/ip_forward`
`sysctl -p`
防火墙规则:
`iptables -t nat -A POSTROUTING -o wlp4s0 -j MASQUERADE`
`iptables-save`
4.刻写虚拟机镜像
* 完整安装一个debian基础系统环境，使用libvirt图形管理工具，创建系统盘，挂载安装镜像img文件。
* 进入debian虚拟机，使用dd命令刻写镜像到系统盘
`dd if=/dev/sda of=/dev/sdb sda为镜像文件，sdb为系统盘`
* 创建虚拟机，添加系统盘，网卡两张，连接外网的设备可使用共享设备，填入桥接接口br0,或者使用NAT 网络
* 内网网卡必须使用共享设备网络模式,填入桥接接口名br1
* wan口使用NAT 模式须设置虚拟机自身DHCP,
5.虚拟机路由初始配置
* 变更防火墙规则，允许外网访问
`vim /etc/config/firewall 
/wan #搜索wan口区，将option input 设为ACCEPT`
* 设置network文件，变更lan口地址，不可与主路由同一网段
`vim /etc/config/network`
`/etc/init.d/firewall restart`
`/etc/init.d/network restart`
* 安装所有带luci界面的软件包
`./OpenWRT_PACK_Installation.sh`
6.进入Web浏览器界面添加额外插件
