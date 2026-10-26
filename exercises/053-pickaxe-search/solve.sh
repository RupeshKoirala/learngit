cd repo
# -S: occurrences of the definition changed -> added (oldest) or removed (newest)
R=$(git log --format=%H -S'function applyCoupon' | head -1)
git tag removed-applyCoupon "$R"
git show "$R" -- src/discount.js | sed -n 's/^+function \([A-Za-z]*\)(.*/\1/p' > ../ANSWER

# -G with a path filter: the code diff that removed '+' from the character class
for c in $(git log --format=%H -G'EMAIL_RE' -- src/validate.js); do
  if git show "$c" -- src/validate.js | grep -q '^-.*\[a-z0-9\._+-\]' && \
     git show "$c" -- src/validate.js | grep -q '^+.*\[a-z0-9\._-\]'; then
    git tag regex-change "$c"; break
  fi
done
