# Behave like the learner's plain shell: no sandbox global config, so file:// must be allowed explicitly.
export GIT_CONFIG_GLOBAL=/dev/null
cd repo
git -c protocol.file.allow=always submodule add -q ../ui-kit.git libs/ui-kit
git commit -q -m "build: add ui-kit as a submodule"
git push -q origin main

( cd "$LG_DIR" && . "$LG_EX/event.sh" )            # = ./lg event

cd libs/ui-kit
git fetch -q --tags
git switch -q --detach v1.1.0
cd ../..
git add libs/ui-kit
git commit -q -m "build: bump ui-kit to v1.1.0"
git push -q origin main

cd "$LG_DIR"
git -c protocol.file.allow=always clone -q --recurse-submodules remotes/storefront.git fresh
git -C fresh submodule status | cut -c2-8 > ANSWER
