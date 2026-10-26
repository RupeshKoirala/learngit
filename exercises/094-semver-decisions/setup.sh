rel() { as bot; tick; git tag -a "$1" -m "Release $1"; }   # rel <tag>  (annotated, on HEAD)
c()   { as "$1"; append "packages/$2/$3" "$4"; tick; git add -A; shift 4; git commit -q "$@"; }

new_repo repo
write README.md "# Brightcart monorepo" "" "packages/sdk      JS client for the Brightcart API (stable)" \
  "packages/widgets  embeddable shop widgets (pre-1.0)" "packages/cli      command-line tool (stable)"
write packages/sdk/index.js "// Brightcart SDK"
write packages/widgets/index.js "// Brightcart widgets"
write packages/cli/main.js "// Brightcart CLI"
as maya; commit "chore: monorepo layout"
rel cli-v1.1.0
c lena widgets Price.js "// <Price amount>" -m "feat(widgets): Price widget"
rel widgets-v0.4.1
c dev sdk client.js "// client" -m "feat(sdk): typed client"
rel sdk-v2.3.0
c dev cli main.js "// --json flag" -m "feat(cli): --json output"
rel cli-v1.2.0
c lena widgets Price.js "// currency symbol" -m "fix(widgets): currency symbol position"
rel widgets-v0.4.2
c dev sdk client.js "// timeout" -m "fix(sdk): honour request timeout"
rel sdk-v2.3.1

day 5
c dev  sdk     client.js "// retry 503" -m "fix(sdk): retry once on HTTP 503"
c lena widgets Price.js  "// prop renamed to cents" -m "feat(widgets)!: rename Price prop 'amount' to 'cents'"
c dev  cli     config.js "// missing config" -m "fix(cli): friendly error when config is missing"
c dev  sdk     orders.js "// listOrders" -m "feat(sdk): add listOrders()"
c jo   cli     README.md "usage docs" -m "docs(cli): usage examples"
c dev  sdk     client.js "// connect returns a Promise" -m "refactor(sdk): simplify connection handling" \
  -m "Connection setup is now async end to end." \
  -m "BREAKING CHANGE: Client.connect() returns a Promise instead of a connected client"
c lena widgets Cart.js   "// mini cart" -m "fix(widgets): mini cart overflow on mobile"
c bot  cli     deps.txt  "yargs 17" -m "chore(cli): bump yargs"
remember released

git switch -q -c feature/retry-backoff
c dev sdk client.js "// backoff" -m "feat(sdk): exponential backoff"
c dev sdk client.js "// jitter" -m "feat(sdk): add jitter to backoff"
git switch -q main
as you
