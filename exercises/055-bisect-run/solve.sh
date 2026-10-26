printf '%s\n' '#!/bin/sh' '[ -f bin/price ] || exit 125' 'exec sh test/run.sh' > bisect-test.sh
chmod +x bisect-test.sh
cd repo
git bisect start main v2.0 >/dev/null
git bisect run ../bisect-test.sh >/dev/null 2>&1
git tag first-bad refs/bisect/bad
git bisect reset >/dev/null 2>&1
