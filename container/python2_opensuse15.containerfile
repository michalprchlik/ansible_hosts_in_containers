FROM opensuse/leap

RUN zypper refresh && zypper install --no-confirm openssh sudo python2 python-xml curl hostname cron tar gzip nano && \
    zypper clean  && \
    mkdir -p /run/dbus && dbus-daemon --system && \
    ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && \
    ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa

ADD id_rsa.pub /home/user/.ssh/authorized_keys
RUN useradd -m -d /home/user user && \
    mkdir -p /home/user/.ssh && \
    groupadd wheel && \
    groupadd mail && \
    groupadd user && \
    usermod -aG wheel user && \
    usermod -aG user user && \
    sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=\(ALL\) NOPASSWD: ALL/g' /etc/sudoers && \
    chown -R user:user /home/user && \
    chmod 600 /home/user/.ssh/authorized_keys



EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]