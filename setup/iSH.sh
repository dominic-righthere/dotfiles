echo "set a new password for iSH"
passwd

# GITHUB
echo "set up github for iSH"
if [ -f $HOME/.ssh/ed25519_github.pub ]; then
    echo "github setup exists"
else
    ssh-keygen -t ed25519 -C "github" -f ~/.ssh/ed25519_github
    source ./github-iSH.sh
    chmod 600 ~/.ssh/config
fi
echo "Copy ~/.ssh/ed25519_github.pub and paste below to https://github.com/settings/ssh/new"
