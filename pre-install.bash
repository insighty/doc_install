##Docker install for dcos
sudo yum install -y epel-release
sudo yum install -y net-tools
sudo yum install -y wget
wget https://github.com/insighty/doc_install/raw/master/docker_install.bash
chmod +x docker_install.bash
bash docker_install.bash