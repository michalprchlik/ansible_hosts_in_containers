FROM ubuntu:16.04

ENV NOTVISIBLE "in users profile"

RUN apt-get update && apt-get install -y openssh-server python3 sudo curl cron nano && \
    mkdir /var/run/sshd && \
    apt-get clean && \
    echo "export VISIBLE=now" >> /etc/profile

ADD id_rsa.pub /home/user/.ssh/authorized_keys
RUN useradd -m -d /home/user user && \
    usermod -aG sudo user && \
    mkdir -p /home/user/.ssh && \
    sed -i 's/sudo\tALL=(ALL:ALL) ALL/sudo\tALL=\(ALL:ALL\) NOPASSWD: ALL/g' /etc/sudoers && \
    chown -R user:user /home/user && \
    chmod 600 /home/user/.ssh/authorized_keys

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]