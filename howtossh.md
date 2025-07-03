in vm:
su -
apt-get update
apt-get install openssh-server

VM > Settings > Network > Advanced > Port Forwarding

Name: ssh
Protocol: TCP
Host IP:
Host Port: 3022
Guest IP:
Guest Port: 22

in host:
ssh shahjalal@127.0.0.1 -p 3022
