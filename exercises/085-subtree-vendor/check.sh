v10=$(saved v10); v11=$(saved v11); root=$(saved upstream_root)
U="$LG_DIR/remotes/pricing-rules.git"
vendor_matches() { [ "$(git rev-parse -q --verify HEAD:vendor/pricing-rules 2>/dev/null)" = "$(git --git-dir="$U" rev-parse "$v11^{tree}")" ]; }
is_plain_dir()   { [ "$(git ls-tree HEAD vendor/ 2>/dev/null | awk '$4=="vendor/pricing-rules"{print $1}')" = "040000" ]; }
has_split()      { [ -n "$(git log --format=%H --grep="git-subtree-split: $1" HEAD)" ]; }
outside_same()   { [ -z "$(git diff --name-only "$(saved start)" HEAD -- . ':(exclude)vendor')" ]; }

in_repo
expect     "no operation in progress"                                   no_operation
expect     "you're on main"                                             on_branch main
expect     "main still builds on your two storefront commits"           is_ancestor "$(saved start)" main
expect     "vendor/pricing-rules/ is a plain tracked folder"            is_plain_dir
expect_not "no .gitmodules (this isn't a submodule)"                    in_commit HEAD .gitmodules
expect     "vendor/pricing-rules/ is exactly upstream v1.1.0"           vendor_matches
expect     "a squash commit imported v1.0.0 (git-subtree-split trailer)" has_split "$v10"
expect     "a squash commit imported v1.1.0 (git-subtree-split trailer)" has_split "$v11"
expect_not "upstream's individual commits are not in main's history"    is_ancestor "$root" main
expect     "nothing outside vendor/ changed"                            outside_same
expect     "the working tree is clean"                                  clean_tree
finish
