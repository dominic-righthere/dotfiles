email="$(git config user.email)"
ssh-keygen -t ed25519 -C "${email:-github}"
