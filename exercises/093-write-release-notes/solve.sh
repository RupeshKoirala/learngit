cd repo
strip() { sed -E 's/^[a-z]+(\([^)]*\))?!?: /- /'; }
r=v1.4.0..v1.5.0
{
  echo "## v1.5.0"; echo
  echo "### Features"; git log --no-merges --format=%s "$r" -E --grep '^feat(\(|!|:)' | strip; echo
  echo "### Fixes";    git log --no-merges --format=%s "$r" -E --grep '^fix(\(|!|:)' | strip; echo
  echo "### Breaking changes"
  git log --no-merges --format=%s "$r" -E --grep '^[a-z]+(\([^)]*\))?!:' --grep '^BREAKING CHANGE:' | strip
  echo
} > ../new.md
{ echo "# Changelog"; echo; cat ../new.md; tail -n +3 CHANGELOG.md; } > ../cl.md
mv ../cl.md CHANGELOG.md
rm ../new.md
commit "docs: changelog for v1.5.0"
