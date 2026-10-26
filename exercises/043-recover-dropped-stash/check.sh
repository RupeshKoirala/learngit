only_express_changes() {   # status lists exactly cart.js and express.js (staged or not)
  [ "$(git status --porcelain | awk '{print $NF}' | sort | tr '\n' ' ')" = "src/cart.js src/express.js " ]
}

express_as_stashed() { [ -f src/express.js ] && [ "$(git hash-object src/express.js)" = "$(git rev-parse "$(saved express):src/express.js")" ]; }

in_repo
expect "no merge/operation is in progress"                     no_operation
expect "you're on main"                                         on_branch main
expect "main hasn't moved (nothing was committed)"              same_commit main "$(saved main)"
expect "src/cart.js has expressCheckout again"                  file_has src/cart.js "function expressCheckout"
expect "src/express.js is back with the button"                 file_has src/express.js "renderExpressButton"
expect "src/express.js is exactly as it was stashed"            express_as_stashed
expect_not "the dark-mode experiment was not applied"           test -e src/theme.css
expect "README.md has no dark-mode changes"                     file_lacks README.md "dark mode"
expect "only the express-checkout files are changed"            only_express_changes
expect "no conflict markers"                                    no_conflict_markers
finish
