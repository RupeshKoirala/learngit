fresh_is_clone() {
  git -C "$LG_DIR/fresh" config remote.origin.url | grep -q 'remotes/origin\.git' &&
  [ "$(git -C "$LG_DIR/fresh" rev-parse -q --verify main)" = "$(saved origin_main)" ]
}
expect "fresh/ is a clone of remotes/origin.git with the latest main"       fresh_is_clone
in_repo
expect "repo: origin/main is up to date (you fetched)"                      same_commit origin/main "$(saved origin_main)"
expect "repo: your main matches the team's main"                            same_commit main "$(saved origin_main)"
expect "repo: main has no merge commits (fast-forward only)"                no_merges main
expect "ANSWER says how many commits main was behind"                       answer_is 3
expect "repo: local feature/gift-cards tracks origin/feature/gift-cards"    test "$(upstream_of feature/gift-cards)" = origin/feature/gift-cards
expect "repo: feature/gift-cards is Lena's latest commit"                   same_commit feature/gift-cards "$(saved gift_cards)"
expect "repo: the working tree is clean"                                    clean_tree
finish
