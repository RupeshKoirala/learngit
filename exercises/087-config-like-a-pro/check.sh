G="$LG_DIR/gitconfig"; W="$LG_DIR/work/storefront"; O="$LG_DIR/oss/dotfiles"
lg_shows_all() {
  _o=$(cd "$W" && git -c color.ui=false lg 2>/dev/null | head -40) || return 1
  printf '%s\n' "$_o" | grep -q 'feature/gift-cards' && printf '%s\n' "$_o" | grep -q '^[*|]' &&
    printf '%s\n' "$_o" | grep -q 'docs: mention currency'
}
undo_works() {   # try the alias in a throwaway clone that includes the sandbox gitconfig
  _t="$LG_DIR/.lg/undo-test"; rm -rf "$_t"
  git clone -q "$W" "$_t" && cd "$_t" && git config include.path "$G" &&
  _before=$(git rev-parse HEAD) && echo "scratch" > scratch.txt && git add scratch.txt &&
  git commit -q -m "chore: scratch" && git undo >/dev/null 2>&1 &&
  [ "$(git rev-parse HEAD)" = "$_before" ] && [ "$(git diff --cached --name-only)" = "scratch.txt" ]
  _r=$?; cd "$LG_DIR"; rm -rf "$_t"; return $_r
}
has_includeif() { git config --file "$G" --get-regexp '^includeif\.gitdir.*\.path$' >/dev/null; }
email_in()      { [ "$(git -C "$1" config user.email)" = "$2" ]; }
email_not_local() { ! git -C "$W" config --local --get user.email >/dev/null 2>&1; }
origin_is_work_file() { git -C "$W" config --show-origin --get user.email | grep -q 'gitconfig-work'; }
pull_rebase_true() { [ "$(git -C "$W" config --bool pull.rebase)" = true ] && ! git -C "$W" config --local --get pull.rebase >/dev/null 2>&1; }

expect "alias lg is defined in the sandbox gitconfig"                    git config --file "$G" alias.lg
expect "git lg draws a graph that includes feature/gift-cards"           lg_shows_all
expect "alias undo is defined in the sandbox gitconfig"                  git config --file "$G" alias.undo
expect "git undo removes the last commit and keeps its changes staged"   undo_works
expect "gitconfig has an includeIf \"gitdir:…\" rule"                    has_includeif
expect "gitconfig-work sets user.email = you@brightcart.example"         test "$(git config --file "$LG_DIR/gitconfig-work" user.email 2>/dev/null)" = you@brightcart.example
expect "work/storefront resolves user.email to the work email"           email_in "$W" you@brightcart.example
expect "...and it comes from gitconfig-work (git config --show-origin)"  origin_is_work_file
expect "...not from the repo's own config"                               email_not_local
expect "oss/dotfiles still uses you@personal.example"                    email_in "$O" you@personal.example
expect "pull.rebase is true in the storefront (local override removed)"  pull_rebase_true
in_repo work/storefront
expect "the earlier history is untouched"                                same_commit HEAD~1 "$(saved before_yours)"
expect "your last commit is still 'docs: mention currency'"              msg_is HEAD "docs: mention currency"
expect "your last commit is authored with the work email"                test "$(git log -1 --format=%ae HEAD)" = you@brightcart.example
expect "its content didn't change"                                        rev_file_has HEAD README.md "Prices are shown in USD"
expect "you're on main with a clean working tree"                        sh -c 'git symbolic-ref -q --short HEAD | grep -qx main && test -z "$(git status --porcelain)"'
finish
