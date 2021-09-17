install:
	ssh-keygen -P "" -f "id_rsa"
	mv id_rsa ansible
	mv id_rsa.pub container
	chmod 600 ansible/id_rsa
	chmod 600 container/id_rsa.pub
	podman build -f container/python2_centos7.containerfile       --no-cache -t localhost/python2_centos7       ./container
	podman build -f container/python2_opensuse15.containerfile    --no-cache -t localhost/python2_opensuse15    ./container
	podman build -f container/python2_oracle_linux7.containerfile --no-cache -t localhost/python2_oracle_linux7 ./container
	podman build -f container/python3_centos8.containerfile       --no-cache -t localhost/python3_centos8       ./container
	podman build -f container/python3_fedora31.containerfile      --no-cache -t localhost/python3_fedora31      ./container
	podman build -f container/python3_ubuntu16.containerfile      --no-cache -t localhost/python3_ubuntu16      ./container

run:
	-podman rm -f localhost/python2_centos7 localhost/python2_opensuse15 localhost/python2_oracle_linux7 localhost/python3_centos8 localhost/python3_ubuntu16 localhost/python3_fedora31
	podman run --rm -d -p 3301:22 --restart always -h python2_centos7       --name python2_centos7       localhost/python2_centos7
	podman run --rm -d -p 3302:22 --restart always -h python2_opensuse15    --name python2_opensuse15    localhost/python2_opensuse15
	podman run --rm -d -p 3303:22 --restart always -h python2_oracle_linux7 --name python2_oracle_linux7 localhost/python2_oracle_linux7
	podman run --rm -d -p 3304:22 --restart always -h python3_centos8       --name python3_centos8       localhost/python3_centos8
	podman run --rm -d -p 3305:22 --restart always -h python3_fedora31      --name python3_fedora31      localhost/python3_fedora31
	podman run --rm -d -p 3306:22 --restart always -h python3_ubuntu16      --name python3_ubuntu16      localhost/python3_ubuntu16

remove:
	-podman rm  -f python2_centos7 python2_opensuse15 python2_oracle_linux7 python3_centos8 python3_fedora31 python3_ubuntu16
	-podman rmi -f python2_centos7 python2_opensuse15 python2_oracle_linux7 python3_centos8 python3_fedora31 python3_ubuntu16