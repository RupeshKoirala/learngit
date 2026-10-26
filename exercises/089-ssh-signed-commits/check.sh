K="$LG_DIR/keys"
local_cfg() { git config --local --get "$1" 2>/dev/null; }
signers_ok() {
  _f=$(local_cfg gpg.ssh.allowedSignersFile) || return 1
  [ -f "$_f" ] && [ -f "$K/signing_key.pub" ] || return 1
  _key=$(awk '{print $2}' "$K/signing_key.pub")
  grep -v '^#' "$_f" | grep -F "$(git config user.email)" | grep -qF "$_key"
}
good_sig() { git verify-commit "$1" 2>&1 | grep -q 'Good "git" signature'; }
tag_ok()   { [ "$(git cat-file -t v1.4.0 2>/dev/null)" = tag ] && same_commit v1.4.0 HEAD && git verify-tag v1.4.0 2>&1 | grep -q 'Good "git" signature'; }

in_repo
expect "a throwaway ed25519 key exists at keys/signing_key(.pub)"      sh -c "[ -f '$K/signing_key' ] && grep -q '^ssh-ed25519 ' '$K/signing_key.pub'"
expect "repo config: gpg.format = ssh"                                 test "$(local_cfg gpg.format)" = ssh
expect "repo config: user.signingkey is the sandbox key"              sh -c "git config --local user.signingkey | grep -q 'keys/signing_key'"
expect "repo config: commits are signed by default"                   test "$(git config --local --bool commit.gpgsign)" = true
expect "repo config: tags are signed by default"                      test "$(git config --local --bool tag.gpgsign)" = true
expect "allowed signers file trusts your key for your commit email"   signers_ok
expect "existing history wasn't rewritten"                            same_commit HEAD~1 "$(saved before)"
expect "HEAD is 'feat(checkout): add gift wrap option'"               msg_is HEAD "feat(checkout): add gift wrap option"
expect "HEAD contains src/giftwrap.js"                                in_commit HEAD src/giftwrap.js
expect "HEAD has a good SSH signature (git verify-commit)"            good_sig HEAD
expect "v1.4.0 is a signed annotated tag on HEAD (git verify-tag)"    tag_ok
expect "the working tree is clean"                                    clean_tree
finish
