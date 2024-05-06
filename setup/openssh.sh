ssh-keygen -A
passwd
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
/usr/sbin/sshd
echo 'connect by ssh root@192.168.0.24'

