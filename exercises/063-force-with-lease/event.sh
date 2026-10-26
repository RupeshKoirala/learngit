# Maya, reviewing your PR, pushes a small fix straight to your branch.
[ -f "$LG_DIR/.lg/clock" ] && LG_CLOCK=$(cat "$LG_DIR/.lg/clock")
tick 600
cd "$LG_DIR/.team/maya"
git fetch -q origin
if git log --format=%s origin/feature/order-notes | grep -q '^Escape HTML in order notes$'; then
  echo "Maya already pushed her fix to feature/order-notes."; exit 0
fi
if ! git merge-base --is-ancestor "$(git rev-parse origin/main)" origin/feature/order-notes; then
  echo "Maya: \"I'll wait until your rebased branch is on origin — force-push it first (step 1).\""; exit 1
fi
git switch -q -C feature/order-notes origin/feature/order-notes
as maya
write src/escape.js "// Escape user input before putting it in HTML" "function escapeHtml(s) {" "  return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');" "}" "" "module.exports = { escapeHtml };"
commit "Escape HTML in order notes"
git push -q origin feature/order-notes
git switch -q main
echo "Maya (in the PR): \"Pushed a small XSS fix to your branch — please keep it!\""
