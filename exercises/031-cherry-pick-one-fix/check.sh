pid() { git show "$1" 2>/dev/null | git patch-id --stable | cut -d' ' -f1; }
same_change() { [ -n "$(pid "$1")" ] && [ "$(pid "$1")" = "$(pid "$2")" ]; }

in_repo
expect "no cherry-pick is in progress"                        no_operation
expect "you're on main"                                       on_branch main
expect "feature/gift-cards is untouched"                      same_commit feature/gift-cards "$(saved gift)"
expect "main has exactly one new commit on top of where it was" sh -c "git merge-base --is-ancestor $(saved main) main && [ \$(git rev-list --count $(saved main)..main) = 1 ]"
expect "the new commit is 'Fix formatPrice for negative amounts'" msg_is main "Fix formatPrice for negative amounts"
expect "it carries exactly the same change as Dev's commit"   same_change main "$(saved fix)"
expect "Dev Patel is still credited as the author"            test "$(author_of main)" = "Dev Patel <dev@brightcart.example>"
expect "no gift-card code reached main"                       sh -c "! git cat-file -e main:src/giftcard.js"
expect "the bug is fixed on main (no BUG marker in src/)"     sh -c "! git grep -q BUG main -- src"
expect "the working tree is clean"                            clean_tree
finish
