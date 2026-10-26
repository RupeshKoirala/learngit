R="$LG_DIR/remotes/monorepo.git"
missing_blobs() { [ "$(git rev-list --objects --all --missing=print 2>/dev/null | grep -c '^?')" -gt 0 ]; }
sparse_is_payments() { [ "$(git sparse-checkout list 2>/dev/null | tr -d '\r')" = "services/payments" ]; }
branch_diff_ok() { [ "$(git --git-dir="$R" diff --name-only main fix/payments-timeout 2>/dev/null)" = "services/payments/retry.js" ]; }
remote_timeout() { git --git-dir="$R" show fix/payments-timeout:services/payments/retry.js 2>/dev/null | grep -q 'TIMEOUT_MS = 15000;'; }

expect "the server allows filtered clones (uploadpack.allowFilter)"   test "$(git --git-dir="$R" config --bool uploadpack.allowFilter)" = true
expect "slim/ exists and is a git repo"                               is_repo "$LG_DIR/slim"
if is_repo "$LG_DIR/slim"; then
  in_repo slim
  expect "slim is a partial clone with filter blob:none"              test "$(git config remote.origin.partialclonefilter)" = "blob:none"
  expect "old blobs (like past asset versions) were never downloaded" missing_blobs
  expect "sparse-checkout uses cone mode"                             test "$(git config --bool core.sparseCheckoutCone)" = true
  expect "sparse-checkout is exactly services/payments"               sparse_is_payments
  expect "services/payments/ is in the working tree"                  test -f services/payments/retry.js
  expect "top-level files are there too (README.md)"                  test -f README.md
  expect "other services, web/ and assets/ are not checked out"       sh -c '[ ! -e services/catalog ] && [ ! -e services/search ] && [ ! -e web ] && [ ! -e assets ]'
fi
expect "origin has branch fix/payments-timeout"                      remote_has_branch monorepo fix/payments-timeout
expect "the branch changes only services/payments/retry.js"          branch_diff_ok
expect "the pushed retry.js has TIMEOUT_MS = 15000"                  remote_timeout
finish
