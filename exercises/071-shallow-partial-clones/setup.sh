R="$LG_DIR/remotes/origin.git"
new_bare "$R"
git --git-dir="$R" config uploadpack.allowFilter true          # GitHub has this on; a local bare repo needs it for --filter
new_repo "$LG_DIR/.team/maya"
brightcart_skeleton
write VERSION "3.0.0"
as maya; commit "Initial storefront"
as dev
write src/shipping.js "// Shipping" "const FREE_SHIPPING_THRESHOLD = 5000; // cents, product decision 2024-11" "" "function shippingCost(total) {" "  return total >= FREE_SHIPPING_THRESHOLD ? 0 : 599;" "}" "" "module.exports = { shippingCost };"
commit "Free shipping threshold"
# A product catalog that changes a lot (big blobs in history: what partial clones skip).
i=1
while [ $i -le 12 ]; do
  case $((i % 4)) in 0) as lena;; 1) as maya;; 2) as jo;; 3) as sam;; esac
  write data/catalog.csv "sku,name,price,stock"
  n=1; while [ $n -le 200 ]; do echo "SKU-$n,Product $n (rev $i),$((n * 100 + i)),$(( (n * i) % 50 ))" >> data/catalog.csv; n=$((n + 1)); done
  commit "Catalog import #$i"
  i=$((i + 1))
done
as lena; replace src/shipping.js "function shippingCost\(total\) \{" "function shippingCost(total, zone) {\n  if (zone === 'INTL') return 1999;"; commit "International shipping rate"
as jo;   replace src/shipping.js "\/\/ Shipping" "\/\/ Shipping costs (all amounts in cents)"; commit "Clarify shipping units"
as maya; append src/shipping.js "// see docs/shipping.md for the rules"; commit "Link shipping docs"
as bot;  write VERSION "3.2.0"; commit "Bump version to 3.2.0"
git remote add origin "$R"
git push -q -u origin main
remember origin_main

# The CI workspace: a depth-1 clone (that's what most CI checkouts do by default).
cd "$LG_DIR"
git clone -q --depth 1 "file://$R" repo
git -C repo config user.name "$LG_LEARNER_NAME"; git -C repo config user.email "$LG_LEARNER_EMAIL"
