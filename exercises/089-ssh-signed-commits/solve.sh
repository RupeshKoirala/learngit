export GIT_CONFIG_GLOBAL=/dev/null SSH_AUTH_SOCK=
cd repo
ssh-keygen -q -t ed25519 -C "$(git config user.email)" -N "" -f ../keys/signing_key
KEYS=$(cd ../keys && pwd)
git config gpg.format ssh
git config user.signingkey "$KEYS/signing_key"
git config commit.gpgsign true
git config tag.gpgsign true
echo "$(git config user.email) $(cat "$KEYS/signing_key.pub")" > "$KEYS/allowed_signers"
git config gpg.ssh.allowedSignersFile "$KEYS/allowed_signers"
git commit -q -m "feat(checkout): add gift wrap option"
git tag -s v1.4.0 -m "Release 1.4.0"
git log --show-signature -1 >/dev/null
