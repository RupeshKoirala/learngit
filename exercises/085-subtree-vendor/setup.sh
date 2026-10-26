# The platform team's pricing-rules library (its own repo, with releases as tags).
new_bare "$LG_DIR/remotes/pricing-rules.git"
new_repo "$LG_DIR/.team/pricing-rules"
as dev
write README.md "# pricing-rules" "" "Shared price, tax and rounding rules for Brightcart services."
write VERSION "1.0.0"
write rules.js "// Rounding rules" "function roundCents(x) {" "  return Math.floor(x);" "}" "" "module.exports = { roundCents };"
commit "feat: rounding rules"
write tax.js "// Tax rules" "const RATES = { US: 0.07, DE: 0.19 };" "function taxFor(cents, country) {" "  return cents * (RATES[country] || 0);" "}" "" "module.exports = { taxFor };"
commit "feat: tax rules"
write test/rules.test.js "// roundCents(10.6) should be 11"
commit "test: rounding cases"
git tag -a v1.0.0 -m "pricing-rules 1.0.0"
day
write VERSION "1.1.0"
replace rules.js "Math\.floor\(x\)" "Math.round(x)"
commit "fix: round half up instead of truncating"
replace tax.js "DE: 0\.19 \}" "DE: 0.19, FR: 0.20 }"
commit "feat: add French VAT"
git tag -a v1.1.0 -m "pricing-rules 1.1.0"
git remote add origin "$LG_DIR/remotes/pricing-rules.git"
git push -q origin main --tags
remember v10 v1.0.0
remember v11 v1.1.0
remember upstream_root "HEAD~4"

# The storefront.
new_repo "$LG_DIR/repo"
brightcart_skeleton
as maya; commit "chore: initial storefront"
as lena; append src/price.js "" "// TODO: use the shared rounding rules"
         commit "chore(price): note shared rounding todo"
remember start
as you
