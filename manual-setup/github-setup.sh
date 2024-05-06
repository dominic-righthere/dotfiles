# github setup

ssh-keygen -t ed25519 -C "github" -f ~/.ssh/ed25519_github
cat << EOF >> /root/.ssh/config
Host github.com
    IdentityFile ~/.ssh/ed25519_github
EOF
chmod 600 ~/.ssh/config
echo "copy and paste below to https://github.com/settings/ssh/new"
cat ~/.ssh/ed25519_github.pub
