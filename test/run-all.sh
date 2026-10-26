#!/usr/bin/env bash
# Self-test for every exercise: setup -> check must FAIL -> solve.sh -> check must PASS.
# Usage: test/run-all.sh [number-or-name ...]      (CI runs it on Linux and on macOS with /bin/bash 3.2)
set -u
ROOT=$(cd "$(dirname "$0")/.." && pwd)
export LEARNGIT_HOME; LEARNGIT_HOME=$(mktemp -d "${TMPDIR:-/tmp}/lgtest.XXXXXX")
BASH_BIN=${LG_TEST_BASH:-bash}
fails=0; n=0; skipped=0

list() {
  if [ $# -gt 0 ]; then for q in "$@"; do (cd "$ROOT" && for d in exercises/*/; do b=$(basename "$d"); case "$b" in *"$q"*|"$(printf '%03d' "$((10#${q}))" 2>/dev/null)"-*) echo "$b";; esac; done); done
  else (cd "$ROOT/exercises" && for d in [0-9][0-9][0-9]-*/; do echo "${d%/}"; done); fi
}

for e in $(list "$@"); do
  ex="$ROOT/exercises/$e"
  if grep -q '^ci=skip' "$ex/meta" 2>/dev/null || [ ! -f "$ex/solve.sh" ]; then skipped=$((skipped+1)); continue; fi
  n=$((n+1))
  out=$("$BASH_BIN" "$ROOT/lg" start "$e" 2>&1) || { echo "FAIL $e: setup failed"; echo "$out" | tail -15; fails=$((fails+1)); continue; }
  if "$BASH_BIN" "$ROOT/lg" check "$e" >/dev/null 2>&1; then echo "FAIL $e: check passes before solving"; fails=$((fails+1)); continue; fi
  w=$(sed -n 's/^workdir=//p' "$ex/meta" 2>/dev/null); w=${w:-repo}
  sout=$( cd "$LEARNGIT_HOME/$e" && \
    LG_ROOT="$ROOT" LG_DIR="$LEARNGIT_HOME/$e" LG_EX="$ex" LG_LEARNER_NAME=Learner LG_LEARNER_EMAIL=learner@example.com \
    GIT_CONFIG_GLOBAL="$ROOT/lib/setup.gitconfig" GIT_CONFIG_NOSYSTEM=1 GIT_EDITOR=true GIT_MERGE_AUTOEDIT=no \
    "$BASH_BIN" -c 'set -e; . "$1"; cd "$LG_DIR"; . "$2"' t "$ROOT/lib/setup.sh" "$ex/solve.sh" 2>&1 ) || { echo "FAIL $e: solve.sh errored"; echo "$sout" | tail -15; fails=$((fails+1)); continue; }
  if cout=$("$BASH_BIN" "$ROOT/lg" check "$e" 2>&1); then echo "ok   $e"
  else echo "FAIL $e: check fails after solve.sh"; echo "$cout" | grep -E '✘|rror' | head -10; fails=$((fails+1)); fi
done
rm -rf "$LEARNGIT_HOME"
echo; echo "$n tested, $fails failed, $skipped skipped (GitHub-only)"
[ "$fails" = 0 ]
