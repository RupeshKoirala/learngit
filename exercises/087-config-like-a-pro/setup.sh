# $LG_DIR/gitconfig stands in for your ~/.gitconfig. Each sandbox repo pulls it in with include.path,
# so this exercise never touches your real global config.
G="$LG_DIR/gitconfig"
cat > "$G" <<CFG
# Pretend global config (in real life: ~/.gitconfig, edited with git config --global)
[user]
	name = $LG_LEARNER_NAME
	email = you@personal.example
[pull]
	rebase = true
[init]
	defaultBranch = main
CFG

personal() { export GIT_AUTHOR_EMAIL=you@personal.example GIT_COMMITTER_EMAIL=you@personal.example; }
wire() {   # point a repo at the pretend global config, drop the identity new_repo set locally
  git config --unset user.name; git config --unset user.email
  git config include.path "$G"
}

# A personal side project.
new_repo "$LG_DIR/oss/dotfiles"
wire
as you; personal
write .bashrc "alias ll='ls -la'"
commit "My dotfiles"

# The work repo.
new_repo "$LG_DIR/work/storefront"
wire
brightcart_skeleton
as maya; commit "chore: initial storefront"
git switch -q -c feature/gift-cards
as lena; write src/giftcards.js "// Gift cards" "module.exports = {};"
         commit "feat(giftcards): scaffold gift cards"
git switch -q main
as dev;  append src/cart.js "" "// TODO: bulk discounts"
         commit "chore(cart): note bulk discount todo"
remember before_yours
as you; personal
append README.md "" "Prices are shown in USD."
commit "docs: mention currency"
# An old bootstrap script left this behind in the repo-local config:
git config pull.rebase false
as you
