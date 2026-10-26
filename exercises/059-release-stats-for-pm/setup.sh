# 059 — release statistics for a PM: shortlog, --since, most-changed files, .mailmap.

dev_home() {   # Dev committing from his personal laptop with a different identity
  as dev
  export GIT_AUTHOR_NAME="Dev P." GIT_AUTHOR_EMAIL="dev.patel@home.example"
  export GIT_COMMITTER_NAME="Dev P." GIT_COMMITTER_EMAIL="dev.patel@home.example"
}
FILES="src/checkout.js src/cart.js src/price.js src/styles.css README.md src/search.js"
pick_file() { echo $FILES | cut -d' ' -f"$1"; }

new_repo repo
brightcart_skeleton
write src/checkout.js "// Checkout"; write src/styles.css "body { margin: 0; }"; write src/search.js "// Search"
as maya; commit "Initial storefront"
for n in 1 2 3 4; do as jo; append src/search.js "// search tweak $n"; commit "Improve search ranking ($n)"; done
as maya; commit "Release 2.0" --allow-empty
git tag -a v2.0 -m "Release 2.0"

# 48 commits between v2.0 and v2.1. Authors: L=Lena D=Dev(work) P=Dev(home laptop) M=Maya J=Jo
WHO="LDMPLJDLMPLJDLPMJLDPMLJDLPMLJDPMLDJPLMDLPJMLPDMJ"
LG_CLOCK=1739318400   # 2025-02-12 00:00 UTC
i=1
while [ "$i" -le 48 ]; do
  [ "$i" = 31 ] && LG_CLOCK=1740960000   # 2025-03-03 00:00 UTC (a quiet week of planning in between)
  c=$(echo "$WHO" | cut -c"$i")
  case $c in L) as lena ;; D) as dev ;; P) dev_home ;; M) as maya ;; J) as jo ;; esac
  # checkout.js is the hot spot: touched by every 2nd commit; plus one rotating file
  if [ $((i % 2)) = 0 ]; then echo "// checkout change $i" >> src/checkout.js; fi
  f=$(pick_file $(( i % 5 + 2 ))); echo "// change $i" >> "$f"
  case $(( i % 6 )) in
    0) m="Checkout: handle edge case #$i" ;; 1) m="Fix flaky behaviour in $(basename "$f")" ;;
    2) m="Refactor $(basename "$f") for readability" ;; 3) m="Add small improvement #$i" ;;
    4) m="Polish UI details ($i)" ;; 5) m="Update copy and docs ($i)" ;;
  esac
  tick 21600; git add -A; git commit -q -m "$m"
  i=$((i + 1))
done
as maya; tick; git tag -a v2.1 -m "Release 2.1"

# work after the release (must not be counted)
LG_CLOCK=1741600000
for n in 1 2 3 4 5 6; do as jo; echo "// next $n" >> src/search.js; commit "Next: search filters ($n)"; done

# expected answers, computed with the canonical mailmap (outside the repo)
mkdir -p "$LG_DIR/.lg"
printf '%s\n' "Dev Patel <dev@brightcart.example> <dev.patel@home.example>" > "$LG_DIR/.lg/mailmap"
git -c mailmap.file="$LG_DIR/.lg/mailmap" shortlog -sn v2.0..v2.1 | head -1 | cut -f2 > "$LG_DIR/.lg/top"
git rev-list --count v2.0..v2.1 > "$LG_DIR/.lg/commits"
git rev-list --count --since=2025-03-01 v2.0..v2.1 > "$LG_DIR/.lg/since"
git log --format= --name-only v2.0..v2.1 | sort | uniq -c | sort -rn | head -1 | awk '{print $2}' > "$LG_DIR/.lg/hotfile"
remember tip
