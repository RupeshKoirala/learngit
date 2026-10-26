# 054 — git bisect by hand. ~30 commits; a design mock-up shows whether the checkout page is broken.

line() { printf '| %-38s |\n' "$1"; }
render() {   # render <tagline> <footer> <wrap> <broken 0|1> <total>
  {
    echo "+----------------------------------------+"
    line "BRIGHTCART              $1"
    echo "+----------------------------------------+"
    line "Blue mug           x1          \$12.00"
    line "Tea sampler        x2          \$18.00"
    line "Gift wrap          x1           \$$3"
    echo "|----------------------------------------|"
    line "Total (incl. tax)              \$$5"
    line ""
    if [ "$4" = 1 ]; then
      printf '| %-38s |  [ Place order ]\n' ""
    else
      line "            [ Place order ]"
    fi
    line "$2"
    echo "+----------------------------------------+"
  } > ui/checkout.txt
}

new_repo repo
brightcart_skeleton
write ui/README.md "ui/checkout.txt is the design mock-up of the checkout page." "Regenerate it whenever you change the layout."
write src/layout.css ".checkout { padding: 16px; }" ".place-order { display: block; margin: 0 auto; }"
render "fresh finds" "Free shipping over \$50" 3.50 0 33.50
as maya; commit "Initial storefront"
as lena; append src/layout.css ".total { font-weight: bold; }"; render "fresh finds" "Free shipping over \$50" 3.50 0 33.50
commit "Bold the order total"
git tag v1.4

# 30 commits after v1.4. The one marked BAD pushes the button out of the frame; it stays broken afterwards.
TAGS="fresh finds|new arrivals|spring sale|cozy picks|gift ideas|daily deals"
FOOTS="Free shipping over \$50|Returns within 30 days|Secure checkout|Questions? Chat with us|Gift cards available"
WRAPS="3.50:33.50|2.95:32.95|3.95:33.95"
broken=0; i=1
while [ "$i" -le 30 ]; do
  case $i in
     1) who=lena; msg="Add hover state to checkout links";              css=".checkout a:hover { text-decoration: underline; }" ;;
     2) who=jo;   msg="Rename tagline for spring campaign";             css="/* campaign: spring */" ;;
     3) who=dev;  msg="Load fonts asynchronously";                      css="@font-face { font-display: swap; }" ;;
     4) who=lena; msg="Use design tokens for colours";                  css=":root { --brand: #2e7d32; }" ;;
     5) who=maya; msg="Remove unused checkout styles";                  css="/* removed .legacy-cart */" ;;
     6) who=jo;   msg="Show returns policy in footer";                  css=".footer { font-size: 12px; }" ;;
     7) who=lena; msg="Increase contrast of muted text";                css=".muted { color: #555; }" ;;
     8) who=dev;  msg="Cheaper gift wrap price in mock-up";             css="/* gift wrap now 2.95 */" ;;
     9) who=lena; msg="Fix Place order button alignment";               css=".place-order { text-align: center; }" ;;
    10) who=jo;   msg="Add focus ring for keyboard users";              css=":focus-visible { outline: 2px solid var(--brand); }" ;;
    11) who=maya; msg="Tidy CSS ordering";                              css="/* sorted */" ;;
    12) who=lena; msg="Responsive breakpoint for tablets";              css="@media (max-width: 900px) { .checkout { padding: 8px; } }" ;;
    13) who=dev;  msg="Mock-up: secure checkout badge";                 css=".badge { display: inline-block; }" ;;
    14) who=jo;   msg="Round corners on cards";                         css=".card { border-radius: 8px; }" ;;
    15) who=lena; msg="Tagline A/B test: cozy picks";                   css="/* ab: cozy */" ;;
    16) who=maya; msg="Bump base font size";                            css="html { font-size: 17px; }" ;;
    17) who=dev;  msg="Lazy-load product thumbnails";                   css="img { content-visibility: auto; }" ;;
    18) who=lena; msg="Align prices to the right";                      css=".price { text-align: right; }" ;;
    19) who=jo;   msg="Tighten checkout layout spacing";                css=".checkout { padding: 8px 12px; } .place-order { margin-left: calc(100% + 8px); }"; broken=1; BAD=1 ;;
    20) who=lena; msg="Dark mode for checkout";                         css="@media (prefers-color-scheme: dark) { body { background: #111; } }" ;;
    21) who=dev;  msg="Mock-up: chat support link";                     css=".chat { float: right; }" ;;
    22) who=maya; msg="Remove !important overrides";                    css="/* no more !important */" ;;
    23) who=lena; msg="Animate add-to-cart button";                     css=".add { transition: transform .1s; }" ;;
    24) who=jo;   msg="Gift ideas tagline for holidays";                css="/* campaign: gifts */" ;;
    25) who=dev;  msg="Preload checkout script";                        css="/* preload */" ;;
    26) who=lena; msg="Underline links in footer";                      css=".footer a { text-decoration: underline; }" ;;
    27) who=maya; msg="Consistent spacing scale";                       css=":root { --space: 4px; }" ;;
    28) who=jo;   msg="Mock-up: daily deals tagline";                   css="/* campaign: deals */" ;;
    29) who=lena; msg="Print stylesheet for receipts";                  css="@media print { .footer { display: none; } }" ;;
    30) who=dev;  msg="Cache-bust stylesheet URL";                      css="/* v=30 */" ;;
  esac
  t=$(echo "$TAGS"  | cut -d'|' -f$(( (i / 5) % 6 + 1 )))
  f=$(echo "$FOOTS" | cut -d'|' -f$(( (i / 3) % 5 + 1 )))
  w=$(echo "$WRAPS" | cut -d'|' -f$(( (i / 8) % 3 + 1 )))
  as "$who"; append src/layout.css "$css"; render "$t" "$f" "${w%%:*}" "$broken" "${w#*:}"
  commit "$msg"
  if [ "${BAD:-0}" = 1 ]; then remember firstbad; BAD=0; fi
  i=$((i + 1))
done
remember tip
