echo "set a new password for iSH"
passwd

# GITHUB
echo "set up github for iSH"

if [ -f ~/.ssh/ed25519_github.pub ]; then
    echo "github setup exists"
else
    ssh-keygen -t ed25519 -C "github" -f ~/.ssh/ed25519_github
    cat << EOF >> /root/.ssh/config
        Host github.com
        IdentityFile ~/.ssh/ed25519_github
    EOF
    chmod 600 ~/.ssh/config
fi

echo "Copy and paste below to https://github.com/settings/ssh/new"
cat ~/.ssh/ed25519_github.pub
