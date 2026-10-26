in_repo
start=$(saved start)
msg()      { git log -1 --format=%B HEAD; }
subject()  { msg | sed -n 1p; }
first_word_lc() { subject | awk '{print tolower($1)}'; }
subj_short()   { _s=$(subject); [ -n "$_s" ] && [ "${#_s}" -le 50 ]; }
subj_capital() { subject | grep -q '^[A-Z]'; }
subj_noperiod(){ ! subject | grep -q '\.[[:space:]]*$'; }
subj_imperative() {
  w=$(first_word_lc)
  case "$w" in embed|need|seed|speed|feed|shred|bring|sing|string|ring) return 0 ;; esac
  case "$w" in *ed|*ing) return 1 ;; esac
  case "$w" in adds|fixes|updates|removes|changes|prevents|blocks|checks|makes|handles|implements|creates|improves|stops) return 1 ;; esac
  return 0
}
blank_second() { [ "$(msg | wc -l)" -ge 3 ] && [ -z "$(msg | sed -n 2p)" ]; }
has_body() {    # at least one non-trailer line after the blank line
  msg | sed -n '3,$p' | grep -vE '^[A-Za-z-]+: |^(Closes|Fixes|Resolves) #[0-9]+' | grep -q '[a-zA-Z]'
}
wrapped()  { ! msg | awk 'length($0) > 72 { bad=1 } END { exit !bad }'; }
closes12() { msg | grep -qE '^(Closes|Fixes|Resolves):? #12[[:space:]]*$'; }
last_para() { msg | awk -v RS= "{p=\$0} END {print p}"; }
coauthor() { last_para | grep -qxE "Co-authored-by: Lena Okafor <lena@brightcart\.example>[[:space:]]*"; }

expect "you're on main, older commits untouched"            is_ancestor "$start" HEAD
expect "there is exactly 1 new commit"                      count_is "$start..HEAD" 1
expect "the commit contains exactly the staged changes"     tree_is_saved HEAD target
expect "subject is at most 50 characters"                   subj_short
expect "subject starts with a capital letter"               subj_capital
expect "subject doesn't end with a period"                  subj_noperiod
expect "subject is imperative (Add/Prevent…, not Added/Adds/Adding)"  subj_imperative
expect "line 2 is blank"                                    blank_second
expect "there is a body explaining what and why"            has_body
expect "no line is longer than 72 characters"               wrapped
expect "the message closes issue #12 (Closes #12)"          closes12
expect "Lena is credited with a Co-authored-by trailer"     coauthor
expect "the working tree is clean"                          clean_tree
finish
