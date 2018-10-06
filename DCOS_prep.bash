## DCOS node prep

sudo yum install epel-release -y
sudo yum -y install yum-utils
sudo yum -y groupinstall development

echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers


sudo adduser centos
sudo usermod -aG wheel centos
mkdir /home/centos/.ssh
chmod 700 /home/centos/.ssh
touch /home/centos/.ssh/authorized_keys
chmod 600 /home/centos/.ssh/authorized_keys

sudo tee /home/centos/.ssh/authorized_keys <<-'EOF'
ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEAyqMBBwNoS1sc8+xHXDO4NsbgnTbWBaz9XH3BpftqNvfFG3rC6PN3zRCYksIuqsHq9kdcyKqkeGm9bnFFb1uqtve03kRCOnBxOsgyo3aNdOKmhsvTQqpPv9emNqtBFgDZiSsKjJLTJDD2jm4lnSGiW8WKWKs7CBKO+OoXqANlQ4k= rsa-key-20170109
ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAmhWyrY4ioi359ddNtEtXvxAJ5J6MvWJkier46YfRiup4viQu+li05KjueYdqFt2t1PnjxARRAhxHmzpFMhD/0T+yblw45uIJzx4sJ89Q+iEsd4Ti5sbdb34K67/eZZ+lEys4Fr+3CWElRAazkTjKt6qfnSRyTtPMWD7doT4KnXBvumCnzShJf5JRYA2yXY7yqEjd3zgntZfKwIPGH7GBX49WgF6SWGP0to661QjVoE0WjqsbuBzHjRVtbqSU4P6ImZ5g/KNKtEiq/NOWCvhwZO213BV93tc63bpxbenKbhuuWpMknWr0wHLHoGNVrGjuYs0hv+e4plUIKkl4maXc3w==
ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAmeZenDQzOu1ilMHmvFuBWAyckChRmV6NI37uZZuUaqpHqL96sELYqssIe2r/RD6bWdlwZyy0UwK6cuuyHGzOHa1cTV5bT2rLii9yvo5aXlpdm+UdiuSi5iCfPPGAIKAu7uauQSDtvo9sqq6A2EOb//6DXKiySYcHP1Deh/crzv1Lu+XLpEHVJdSsuPs/hqCx0+lv7iZSr6Wo/Jf6vI5Du7MTfxm3UJ+rthfxiRU1qZDEdl78NwfqGujNkVvafFoqXRb6NGZ+688KN7oEIa+nwdawWbegAzyyjwck1sphNsBwPH8yNdVExLsnwYBBBXwZ+TU1E4cjgG/wEzPl8NSysQ==
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNt771sqVAsrvtLSp7tTAhYNCja3S7K/jVF0DFZY7+p9z6MyXmHD6Ql9G8TjJSXGesWR14w/1M5rkaGwyfjIjBlYaz0ZmIJDWpSlg/paQLyHkNe8sdQb7z1z+BU24aVB8pq5flTTJYZgz5sxA5xgycOMvCa870h+Yz7aAfR7haw6N4QNbltqIlrNCtGdysmxCUYcIljr0UO9Pu7htCVtr9oT3WuOku9g5xaVvKaHSafft4Mm3qDSYLj5fulb/Qur0xzqu8p9XNotpBzejNRZlCEMpBZK9Z/dU21Lj1j+7RyC+CcQwFS4RAIyIyGvStY0w1AiR2qmbjbeHQQ841GKiL root@localhost.localdomain
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcoDUSJJEcAt2iiaEuxYYic68QPacWRvbOq/PubCQaTbC9EyJPyl2bCCt30oXGN4+krjXtRzv/6uF9qGdtYMaDArIW0b2Ezyx17QWCM59+jiO1+xYwUmcFjqxyo5WFf1qVjwxd4NElw7uG8GqAvHMCNTswOVL6ed4ds/QDZMTItPgV0LkOmoFM8/yUqIo5NkdMuZh7Yyzy+uy2ef0YDfU7qK2UCToNG5/dQezOYjobR+KpARWziKEx/5D8vMjLBxNxrzb4mXZ2c2o/oYfsI5TRc6LzjLd+8SjbbQgyOKhphIuPrTE9KnjCP24vo9BW7JJv/yA/co8B+c62BsMpeZ8D 
EOF




sudo mkfs -t xfs -n ftype=1 /dev/xvda
sudo yum install -y tar xz unzip curl ipset

wget https://www.python.org/ftp/python/2.7.14/Python-2.7.14.tgz
tar xzf Python-2.7.14.tgz
cd Python-2.7.14
./configure
sudo make altinstall

sudo yum  install -y python-pip 

sudo yum -y install https://centos7.iuscommunity.org/ius-release.rpm
sudo yum -y install python36u-3.6.5

sudo pip install virtualenv
sudo pip install --upgrade pip

sudo iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
sudo iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT


sudo iptables -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT
sudo iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT



echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf

sudo systemctl stop firewalld && sudo systemctl disable firewalld

LANG=en_US.utf-8
LC_ALL=en_US.utf-8
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network

sudo tee /etc/modules-load.d/overlay.conf <<-'EOF'
overlay
EOF

timedatectl set-ntp true
sudo sed -i s/SELINUX=enforcing/SELINUX=permissive/g /etc/selinux/config 
sudo groupadd nogroup 
sudo groupadd docker 
sudo reboot

