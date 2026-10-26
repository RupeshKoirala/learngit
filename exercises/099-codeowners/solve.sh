cd repo
git shortlog -sn HEAD -- src/catalog/ >/dev/null
write .github/CODEOWNERS \
  "# Last matching pattern wins. Keep general rules first, specific rules last." \
  "*                         @brightcart/maintainers" \
  "" \
  "/src/checkout/            @devpatel" \
  "/src/catalog/             @lenaokafor" \
  "/src/search/              @jonovak" \
  "/src/checkout/payments/   @devpatel @brightcart/security" \
  "" \
  "/infra/                   @brightcart/platform" \
  "/.github/workflows/       @brightcart/platform" \
  "/docs/                    @samrivera" \
  "" \
  "*.sql                     @brightcart/dba" \
  "/.github/CODEOWNERS       @mayachen"
commit "chore: add CODEOWNERS"
