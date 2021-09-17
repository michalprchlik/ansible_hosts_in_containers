FROM oraclelinux:7

RUN yum -y install openssh-server openssh-clients epel-release sudo which python2 cronie nano && \
    rm -f /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_ed25519_key /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    yum clean all && \
    systemctl enable sshd

ADD id_rsa.pub /home/user/.ssh/authorized_keys
RUN useradd -m -d /home/user user && \
    mkdir -p /home/user/.ssh && \
    usermod -aG wheel user && \
    sed -i 's/wheel\tALL=(ALL)\tALL/wheel\tALL=\(ALL\)\tNOPASSWD: ALL/g' /etc/sudoers && \
    chown -R user:user /home/user && \
    chmod 600 /home/user/.ssh/authorized_keys

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]