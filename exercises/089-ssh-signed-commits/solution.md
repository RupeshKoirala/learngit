# Solution

From `repo`:

```bash
ssh-keygen -t ed25519 -C "$(git config user.email)" -N "" -f ../keys/signing_key
KEYS=$(cd ../keys && pwd)

git config gpg.format ssh
git config user.signingkey "$KEYS/signing_key"      # or the .pub file when the key lives in ssh-agent
git config commit.gpgsign true
git config tag.gpgsign true

echo "$(git config user.email) $(cat "$KEYS/signing_key.pub")" > "$KEYS/allowed_signers"
git config gpg.ssh.allowedSignersFile "$KEYS/allowed_signers"

git commit -m "feat(checkout): add gift wrap option"
git tag -s v1.4.0 -m "Release 1.4.0"

git log --show-signature -1
# Good "git" signature for you@… with ED25519 key SHA256:…
git log --format='%h %G? %GS %s'      # G = good, N = none, U = good but unknown signer, B = bad
git verify-commit HEAD && git verify-tag v1.4.0
git cat-file -p HEAD                   # see the raw "gpgsig -----BEGIN SSH SIGNATURE-----" header
```

**Why it works:** with `gpg.format = ssh`, Git hands the commit (or tag) object to `ssh-keygen -Y sign` with
your key and embeds the resulting signature in the object (`gpgsig` header for commits, appended to the
message for tags). Because the signature is *part of the object*, it is covered by the hash: change anything
and the signature no longer verifies. `commit.gpgsign` / `tag.gpgsign` just mean "always add `-S` / `-s`".

Verifying is a separate question: *whose* key is this? SSH keys have no web of trust, so Git asks
`gpg.ssh.allowedSignersFile`, a list of `principal key` lines (principal = email). A commit signed by a key
not in the file shows `U`/"No principal matched" — valid signature, unknown person.

**Real-world notes**
- On GitHub, add the **public** key under *Settings → SSH and GPG keys* as a **Signing key** (separate from
  an authentication key, even if it's the same key). Commits then show **Verified** if the committer email is
  one of your verified emails. Branch protection / rulesets can require it.
- Keep the private key safe: passphrase + `ssh-agent`, or a hardware key (`ed25519-sk` on a YubiKey), or a
  password manager agent (`gpg.ssh.program = op-ssh-sign` for 1Password). When the key lives in the agent,
  point `user.signingkey` at the **.pub** file or use `key::ssh-ed25519 AAAA…`.
- Teams often commit an `allowed_signers` file to the repo (one line per developer) so anyone can verify locally
  and CI can enforce it with `git verify-commit` on every commit of a PR.
- Signatures don't survive history rewriting: `rebase`, `--amend` and `cherry-pick` create new commits, which
  are re-signed only if signing is enabled on the machine doing it. Commits made by GitHub's web UI (merge
  button, squash) are signed with GitHub's own key.
- Sign **tags** for releases at minimum: a signed `v1.4.0` lets anyone downstream check that the release came
  from your team. Combine with Sigstore/gitsign or SLSA provenance for stronger supply-chain guarantees.
- GPG still works (`gpg.format = openpgp`, the default) and is what many older projects require; the concepts
  are identical.
