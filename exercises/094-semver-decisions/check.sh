annotated()  { [ "$(git cat-file -t "refs/tags/$1" 2>/dev/null)" = tag ]; }
tag_ok()     { annotated "$1" && same_commit "$1" "$(saved released)"; }
only_tags()  {   # only_tags <pattern> <expected tags…>   the set of tags matching pattern is exactly the list
  _p="$1"; shift
  [ "$(git tag -l "$_p" | sort | tr '\n' ' ')" = "$(printf '%s\n' "$@" | sort | tr '\n' ' ')" ]
}
describe_ok() {
  [ -f "$LG_DIR/ANSWER" ] || return 1
  _a=$(tr -d ' \n\r\t' < "$LG_DIR/ANSWER")
  case "$_a" in sdk-v3.0.0-2-g*) ;; *) return 1;; esac
  _h=${_a#sdk-v3.0.0-2-g}
  [ "${#_h}" -ge 4 ] && case "$(git rev-parse feature/retry-backoff)" in "$_h"*) return 0;; *) return 1;; esac
}

in_repo
expect "main was not changed"                                same_commit main "$(saved released)"
expect "sdk-v3.0.0 is an annotated tag on main's tip (BREAKING CHANGE footer → major)" tag_ok sdk-v3.0.0
expect "widgets-v0.5.0 is an annotated tag on main's tip (pre-1.0 breaking → minor)"   tag_ok widgets-v0.5.0
expect "cli-v1.2.1 is an annotated tag on main's tip (fix only → patch)"               tag_ok cli-v1.2.1
expect "no other sdk tags were created"                      only_tags 'sdk-v*'     sdk-v2.3.0 sdk-v2.3.1 sdk-v3.0.0
expect "no other widgets tags were created"                  only_tags 'widgets-v*' widgets-v0.4.1 widgets-v0.4.2 widgets-v0.5.0
expect "no other cli tags were created"                      only_tags 'cli-v*'     cli-v1.1.0 cli-v1.2.0 cli-v1.2.1
expect "no stray tags outside the <package>-vX.Y.Z scheme"   test -z "$(git tag -l | grep -vE '^(sdk|widgets|cli)-v[0-9]+\.[0-9]+\.[0-9]+$')"
expect "ANSWER holds the git describe name of feature/retry-backoff" describe_ok
finish
