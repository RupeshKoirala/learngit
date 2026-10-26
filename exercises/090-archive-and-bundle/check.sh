T="$LG_DIR/dist/brightcart-2.0.0.tar.gz"; B="$LG_DIR/usb/brightcart.bundle"; O="$LG_DIR/offsite"
list_tar() { gzip -dc "$T" 2>/dev/null | tar -tf - 2>/dev/null; }
all_prefixed() { _l=$(list_tar) && [ -n "$_l" ] && ! printf '%s\n' "$_l" | grep -qv '^brightcart-2\.0\.0/'; }
tar_has_sources() { tar_has src/cart.js && tar_has src/checkout.js; }
tar_lacks_giftcards() { _l=$(list_tar) && [ -n "$_l" ] && ! printf '%s\n' "$_l" | grep -q 'giftcards'; }
tar_has()   { list_tar | grep -qx "brightcart-2.0.0/$1"; }
tar_lacks_ignored() { _l=$(list_tar) && [ -n "$_l" ] && ! printf '%s\n' "$_l" | grep -qE '^brightcart-2\.0\.0/(tests|\.github|docs/internal)(/|$)|/\.gitattributes$'; }
tar_version() { [ "$(gzip -dc "$T" | tar -xOf - brightcart-2.0.0/VERSION 2>/dev/null)" = "2.0.0" ]; }
tar_commit()  { [ "$(gzip -dc "$T" 2>/dev/null | git get-tar-commit-id 2>/dev/null)" = "$(git rev-parse 'v2.0.0^{commit}')" ]; }
bundle_head() { git bundle list-heads "$B" 2>/dev/null | awk -v r="$1" '$2==r{print $1}'; }
bundle_has()  { [ -n "$(bundle_head "$1")" ] && [ "$(bundle_head "$1")" = "$(git rev-parse "$1")" ]; }
off()         { git -C "$O" "$@"; }

in_repo
expect     "dist/brightcart-2.0.0.tar.gz exists and is a gzipped tar"   sh -c "gzip -dc '$T' | tar -tf - >/dev/null"
expect     "every path in it starts with brightcart-2.0.0/"            all_prefixed
expect     "it contains the sources (src/cart.js, src/checkout.js)"    tar_has_sources
expect     "it was built from v2.0.0 (git get-tar-commit-id)"          tar_commit
expect     "its VERSION file says 2.0.0"                               tar_version
expect     "it doesn't contain unreleased src/giftcards.js"            tar_lacks_giftcards
expect     "export-ignore was respected (no tests/, .github/, docs/internal/, .gitattributes)" tar_lacks_ignored
expect     "usb/brightcart.bundle passes git bundle verify"            git bundle verify "$B"
expect     "the bundle carries main"                                   bundle_has refs/heads/main
expect     "the bundle carries release/2.0"                            bundle_has refs/heads/release/2.0
expect     "the bundle carries the tag v2.0.0"                         bundle_has refs/tags/v2.0.0
expect     "offsite/ is a clone of the bundle"                         sh -c "git -C '$O' config remote.origin.url | grep -q 'brightcart\.bundle$'"
expect     "offsite has main at the same commit as repo"               test "$(off rev-parse -q --verify main 2>/dev/null)" = "$(git rev-parse main)"
expect     "offsite has origin/release/2.0"                            test "$(off rev-parse -q --verify origin/release/2.0 2>/dev/null)" = "$(git rev-parse release/2.0)"
expect     "offsite has the tag v2.0.0"                                test "$(off rev-parse -q --verify v2.0.0 2>/dev/null)" = "$(git rev-parse v2.0.0)"
expect     "git fsck in offsite reports no problems"                   off fsck --no-progress
finish
