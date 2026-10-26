cd repo
m=$(mktemp)
printf '%s\n' \
  "Prevent adding more items than in stock" \
  "" \
  "Orders failed at payment when the cart held more units than the" \
  "warehouse had. Check stock when an item is added so customers see" \
  "the problem immediately instead of at checkout." \
  "" \
  "Closes #12" \
  "Co-authored-by: Lena Okafor <lena@brightcart.example>" > "$m"
tick
git commit -q -F "$m"
