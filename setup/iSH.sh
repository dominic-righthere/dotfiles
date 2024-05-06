echo "set a new password for iSH"
passwd
echo "setup openssh for iSH..."
ssh-keygen -A
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
/usr/sbin/sshd

# github
echo "set up github for iSH"
ssh-keygen -t ed25519 -C "github" -f ~/.ssh/ed25519_github
cat << EOF >> /root/.ssh/config
Host github.com
    IdentityFile ~/.ssh/ed25519_github
EOF
chmod 600 ~/.ssh/config
echo "Copy and paste below to https://github.com/settings/ssh/new"
cat ~/.ssh/ed25519_github.pub
