cd repo
git ls-files -s | awk '$1 == "100755" {print $4}' | xargs chmod 644
git add -A
git update-index --chmod=+x test.sh
chmod 755 test.sh
git commit -q -m "Restore file modes; make test.sh executable"
