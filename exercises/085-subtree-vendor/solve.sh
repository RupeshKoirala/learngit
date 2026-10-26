cd repo
git remote add pricing-rules ../remotes/pricing-rules.git
git subtree add -q --prefix=vendor/pricing-rules pricing-rules v1.0.0 --squash
git subtree pull -q --prefix=vendor/pricing-rules pricing-rules v1.1.0 --squash -m "chore(vendor): update pricing-rules to v1.1.0"
