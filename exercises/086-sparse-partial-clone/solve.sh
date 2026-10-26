export GIT_CONFIG_GLOBAL=/dev/null      # like the learner's own shell
git -C remotes/monorepo.git config uploadpack.allowFilter true
git clone -q --filter=blob:none --sparse "file://$PWD/remotes/monorepo.git" slim
cd slim
ensure_identity
git sparse-checkout set --cone services/payments
git switch -q -c fix/payments-timeout
replace services/payments/retry.js "TIMEOUT_MS = 5000" "TIMEOUT_MS = 15000"
git commit -q -am "fix(payments): raise capture timeout to 15s"
git push -q -u origin fix/payments-timeout
