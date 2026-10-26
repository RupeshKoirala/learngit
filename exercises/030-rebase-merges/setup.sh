new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"

git switch -q -c feature/promo-banner
as you
write src/banner.js "// Promo banner" "function banner(messages) {" "  return { text: messages[0], index: 0 };" "}" "" "module.exports = { banner };"
commit "Add promo banner component"

# Lena builds the theming as a sub-PR against your feature branch.
git switch -q -c banner-styles
as lena
write src/banner-theme.js "// Banner themes" "const THEMES = { sale: { bg: '#d7263d', fg: '#fff' } };" "" "module.exports = { THEMES };"
commit "Add banner color themes"
write src/banner-theme.js "// Banner themes" "const THEMES = {" "  sale: { bg: '#d7263d', fg: '#fff' }," "  dark: { bg: '#111', fg: '#f5f5f5' }," "};" "" "module.exports = { THEMES };"
commit "Add dark-mode banner theme"

git switch -q feature/promo-banner
as you
write src/banner.js "// Promo banner" "function banner(messages) {" "  return { text: messages[0], index: 0, closable: true };" "}" "" "module.exports = { banner };"
commit "Add close button to banner"

# You merge Lena's reviewed sub-PR with a real merge commit, then keep going.
tick
git merge -q --no-ff -m "Merge branch 'banner-styles' into feature/promo-banner" banner-styles
git branch -q -d banner-styles
write src/banner.js "// Promo banner" "const ROTATE_MS = 8000;" "" "function banner(messages) {" "  return { text: messages[0], index: 0, closable: true };" "}" "" "function next(state, messages) {" "  state.index = (state.index + 1) % messages.length;" "  state.text = messages[state.index];" "  return state;" "}" "" "module.exports = { banner, next, ROTATE_MS };"
commit "Rotate banner messages every 8 seconds"
remember original

git switch -q main
day
as maya; append src/cart.js "" "function removeItem(cart, id) {" "  cart.items = cart.items.filter(i => i.id !== id);" "  return cart;" "}"
commit "Add removeItem to cart"

git switch -q feature/promo-banner
