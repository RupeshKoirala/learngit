From `repo`:

```bash
ssh-keygen -t ed25519 -C "$(git config user.email)" -N "" -f ../keys/signing_key
```
`-N ""` = no passphrase (fine for a throwaway; use a passphrase + ssh-agent for real keys).
---
Signing config (absolute paths are safest):

```bash
git config gpg.format ssh
git config user.signingkey "$(cd ../keys && pwd)/signing_key"
git config commit.gpgsign true
git config tag.gpgsign true
```
---
Git can *create* signatures now, but to *verify* it needs to know which key belongs to whom. Each line of the
allowed signers file is `<email> <public key>`:

```bash
echo "$(git config user.email) $(cat ../keys/signing_key.pub)" > ../keys/allowed_signers
git config gpg.ssh.allowedSignersFile "$(cd ../keys && pwd)/allowed_signers"
```
---
```bash
git commit -m "feat(checkout): add gift wrap option"       # signed because of commit.gpgsign (or add -S)
git tag -s v1.4.0 -m "Release 1.4.0"
git log --show-signature -1                                # Good "git" signature for you@…
git log --format='%h %G? %s'                              # G = good, N = no signature
```
