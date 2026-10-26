only_notes_left() { [ "$(git status --porcelain)" = "?? notes.txt" ]; }

in_repo
expect "no merge/rebase is in progress"                         no_operation
expect "you're on feature/free-shipping"                         on_branch feature/free-shipping
expect "main still points at 'Add flat-rate shipping'"           same_commit main "$(saved main)"
expect "the branch has exactly 1 commit on top of main"          count_is main..feature/free-shipping 1
expect "that commit is called 'Add free shipping threshold'"     msg_is feature/free-shipping "Add free shipping threshold"
expect "the commit holds exactly the code of your 3 old commits" tree_is_saved feature/free-shipping original
expect_not "notes.txt is not tracked or committed"               tracked notes.txt
expect "notes.txt still exists on disk with your notes"          file_has notes.txt "ask Sam"
expect "the price.js experiment is gone"                         git diff --quiet HEAD -- src/price.js
expect "git status shows only '?? notes.txt'"                    only_notes_left
expect "ANSWER names the reset mode that would destroy notes.txt" answer_is hard
finish
