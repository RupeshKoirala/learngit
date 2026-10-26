in_repo
tag_at() { tag_exists "$1" && same_commit "$1" "$(saved "$2")"; }
expect "lena-first marks Lena's first commit"                  tag_at lena-first lena_first
expect "march-hotfix marks the only commit of March 1–7"       tag_at march-hotfix hotfix
expect "issue-42 marks the commit that closes #42"             tag_at issue-42 issue42
expect "tax-file marks the commit that created src/tax.js"     tag_at tax-file tax_file
expect "freeship-added marks the commit that added FREESHIP50" tag_at freeship-added freeship
expect "main hasn't moved"                                     same_commit main "$(saved start)"
finish
