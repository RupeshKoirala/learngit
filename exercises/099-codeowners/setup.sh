lenao() {   # Lena's misconfigured laptop identity
  export GIT_AUTHOR_NAME="lena-o" GIT_AUTHOR_EMAIL="lena.okafor@laptop.local" \
         GIT_COMMITTER_NAME="lena-o" GIT_COMMITTER_EMAIL="lena.okafor@laptop.local"
}
c() {       # c <who> <file> <line> <message>
  if [ "$1" = lenao ]; then lenao; else as "$1"; fi
  append "$2" "$3"; commit "$4"
}

new_repo repo
write README.md "# Brightcart storefront"
write package.json "{ \"name\": \"brightcart\" }"
write src/README.md "Source overview"
as maya; commit "chore: initial storefront"

c dev   src/search/index.js        "// search v1 (big initial import)" "feat(search): initial search service"
c dev   src/checkout/cart.js       "// cart"                "feat(checkout): cart"
c dev   src/checkout/payments/stripe.js "// stripe"         "feat(checkout): stripe payments"
c dev   src/catalog/list.js        "// list"                "feat(catalog): product list"
c lena  src/catalog/list.js        "// grid view"           "feat(catalog): grid view"
c maya  infra/terraform/main.tf    "# vpc"                  "infra: vpc"
c dev   src/checkout/queries.sql   "-- orders"              "feat(checkout): order queries"
c jo    src/search/index.js        "// synonyms"            "feat(search): synonyms"
c dev   src/catalog/list.js        "// paging"              "feat(catalog): paging"
c lenao src/catalog/filters.js     "// filters"             "feat(catalog): filters"
c sam   docs/guide.md              "# Guide"                "docs: user guide"
c maya  .github/workflows/ci.yml   "name: ci"               "ci: run tests"
c dev   src/checkout/cart.js       "// totals"              "feat(checkout): totals"
c jo    src/search/index.js        "// typo tolerance"      "feat(search): typo tolerance"
c lena  src/catalog/filters.js     "// price filter"        "feat(catalog): price filter"
c dev   db/migrations/0042_add_giftcards.sql "-- giftcards" "db: gift card table"
c maya  src/search/index.js        "// ranking"             "feat(search): ranking"
c dev   src/catalog/list.js        "// sort"                "feat(catalog): sort"
c dev   src/catalog/list.js        "// cache"               "perf(catalog): cache list"
c lenao src/catalog/list.js        "// badges"              "feat(catalog): badges"
c lena  src/checkout/cart.js       "// cart ui"             "feat(checkout): cart ui"
c jo    src/search/index.js        "// facets"              "feat(search): facets"
c dev   src/checkout/payments/stripe.js "// 3ds"            "feat(checkout): 3-D Secure"
c lena  src/catalog/list.js        "// a11y"                "fix(catalog): a11y labels"
c maya  src/checkout/cart.js       "// lint"                "chore(checkout): lint"
c dev   src/checkout/payments/refund.js "// refunds"        "feat(checkout): refunds"
c sam   docs/guide.md              "## FAQ"                 "docs: FAQ"
as maya
write .mailmap "Lena Okafor <lena@brightcart.example> lena-o <lena.okafor@laptop.local>"
commit "chore: add .mailmap (Lena's laptop identity)"
as you
