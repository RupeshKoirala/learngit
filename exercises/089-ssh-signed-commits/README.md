# Sign commits and tags with an SSH key

After a supply-chain scare at another company, Maya turned on **"Require signed commits"** for `main`.
Anyone can set `user.email` to `maya@brightcart.example` and commit "as Maya"; a **signature** proves the
commit was made by someone holding a specific private key. Since Git 2.34 you can sign with the **SSH key**
you already understand instead of setting up GPG.

Your `feat(checkout): add gift wrap option` change is staged and ready. It's also the 1.4.0 release.

```
* docs: require signed commits for releases    <- main
* feat(cart): add removeItem
* chore: initial storefront
  (staged: src/giftwrap.js)
```

**Sandbox rule:** use a **throwaway key** in the sandbox folder `keys/` (next to `repo`) and put all
settings in **this repo's** config (`git config …`, no `--global`). Your real keys and `~/.gitconfig` stay
untouched. If your global config sets `gpg.ssh.program` (e.g. 1Password's `op-ssh-sign`), also run
`git config gpg.ssh.program ssh-keygen` here.

## Your task

1. Generate an **ed25519** key pair without passphrase at **`keys/signing_key`** (`keys/signing_key.pub`).
2. Configure this repo to sign with it: SSH signature format, that key as the signing key, and sign commits
   and tags by default.
3. Create an **allowed signers** file at `keys/allowed_signers` that trusts your public key for **your commit
   email** (`git config user.email`), and point Git at it, so Git can *verify* signatures.
4. Commit the staged change as **`feat(checkout): add gift wrap option`**, signed.
5. Create a **signed annotated tag `v1.4.0`** on that commit.
6. Look at the result with `git log --show-signature -1`, `git verify-commit HEAD`, `git verify-tag v1.4.0`.

Don't rewrite the existing commits.

## You'll practice

`ssh-keygen`, `gpg.format ssh`, `user.signingkey`, `commit.gpgsign`, `tag.gpgsign`, `git commit -S`,
`git tag -s`, `gpg.ssh.allowedSignersFile`, `git log --show-signature`, `%G?`, `verify-commit`, `verify-tag`.
