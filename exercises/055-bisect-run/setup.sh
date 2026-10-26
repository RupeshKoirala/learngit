# 055 — git bisect run across ~200 commits, with a stretch where the build was broken (needs `skip`).

write_price() {   # the price CLI; $1 = the modulo used for cents (100 = correct, 10 = the bug)
  write bin/price "#!/bin/sh" "# usage: bin/price <cents>   ->  \$D.CC" \
    "awk -v c=\"\$1\" 'BEGIN { printf \"\$%d.%02d\\n\", int(c / 100), c % $1 }'"
  chmod +x bin/price
}

new_repo repo
brightcart_skeleton
write_price 100
write test/run.sh "#!/bin/sh" "# unit tests for bin/price. Exit 0 = pass, 1 = fail." \
  "fail=0" \
  "check() { got=\$(sh bin/price \"\$1\"); [ \"\$got\" = \"\$2\" ] || { echo \"FAIL: price \$1 -> \$got (want \$2)\"; fail=1; }; }" \
  "check 1999 '\$19.99'" "check 500 '\$5.00'" "check 7 '\$0.07'" \
  "[ \$fail = 0 ] && echo 'all price tests passed'" "exit \$fail"
chmod +x test/run.sh
write docs/notes.md "# Engineering notes"
write config/app.env "REGION=eu"
as maya; commit "Initial storefront with price CLI"
git tag v2.0

i=1
while [ "$i" -le 200 ]; do
  case $(( i % 4 )) in 0) as dev ;; 1) as lena ;; 2) as jo ;; 3) as maya ;; esac
  quick=0
  case $i in
    97)  git rm -q bin/price; write lib/price/format.sh "# WIP: new home of the price formatter"
         msg="WIP: move price formatter to lib/ (build broken)" ;;
    98)  append lib/price/format.sh "# TODO: wire up bin/price again"; msg="WIP: price formatter, part 2" ;;
    99)  append lib/price/format.sh "# half-done"; msg="WIP: price formatter, part 3" ;;
    100) append lib/price/format.sh "# reverted plan"; msg="WIP: rethink price module layout" ;;
    101) git rm -rq lib; write_price 100; msg="Revert price module move, keep bin/price" ;;
    137) write_price 10;
         msg="Simplify cents formatting" ;;
    *)   case $(( i % 5 )) in
           0) echo "- note $i: keep functions small" >> docs/notes.md; msg="Docs: engineering note $i" ;;
           1) echo "FLAG_$i=off" >> config/app.env; msg="Add feature flag FLAG_$i" ;;
           2) echo "// cart tweak $i" >> src/cart.js; msg="Cart: small refactor #$i" ;;
           3) echo "// formatting idea $i" >> src/price.js; msg="Price: comment on rounding case $i" ;;
           4) echo "- changelog entry $i" >> README.md; msg="README: changelog entry $i" ;;
         esac; quick=1 ;;
  esac
  if [ $quick = 1 ]; then tick; git commit -qam "$msg"; else commit "$msg"; fi
  [ "$i" = 137 ] && remember firstbad
  i=$((i + 1))
done
remember tip
