#!/bin/sh
rm -f $0
socks_port="55620"
socks_user="admin"
socks_pass="141242"
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X
iptables-save

ips=(
$(hostname -I)
)

# sk5 Installation
chmod +x /usr/local/bin/sk5
cat <<EOF > /etc/systemd/system/sk5.service
[Unit]
Description=The sk5 Proxy Serve
After=network-online.target
[Service]
ExecStart=/usr/local/bin/sk5 -c /etc/sk5/serve.toml
ExecStop=/bin/kill -s QUIT $MAINPID
Restart=always
RestartSec=15s
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable sk5
# sk5 Configuration
mkdir -p /etc/sk5
echo -n "" > /etc/sk5/serve.toml
for ((i = 0; i < ${#ips[@]}; i++)); do
cat <<EOF >> /etc/sk5/serve.toml
[[inbounds]]
listen = "${ips[i]}"
port = $socks_port
protocol = "socks"
tag = "$((i+1))"
[inbounds.settings]
auth = "password"
udp = true
ip = "${ips[i]}"
[[inbounds.settings.accounts]]
user = "$socks_user"
pass = "$socks_pass"
[[routing.rules]]
type = "field"
inboundTag = "$((i+1))"
outboundTag = "$((i+1))"
[[outbounds]]
sendThrough = "${ips[i]}"
protocol = "freedom"
tag = "$((i+1))"
EOF
done
systemctl stop sk5
systemctl start sk5
    echo "###############################################################"
    echo "#        支持系统: CentOS 7+                                  #"
    echo "#        详细说明: socks5 自动安装程序 有问题添加下方         #"
    echo "#                  tg:akanonono                             #"
    echo "###############################################################"
