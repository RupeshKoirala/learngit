`gh pr create --head feature/free-shipping --base main --fill` (the branch is already pushed), then
`gh pr view --web` and go to **Files changed**. Hover a line number and click the blue **+**.
---
In the comment box, the "Add a suggestion" button (±) inserts a block. Whatever is inside replaces the
line(s) you commented on:

````
Spec says "$50.00 or more" - exactly $50 should ship free.
```suggestion
  if (total >= FREE_SHIPPING_FROM) return 0;
```
````
Choose **Start a review** (not "Add single comment"), then **Finish your review** -> **Comment** -> Submit.
---
After submitting, the comment shows **Commit suggestion**. Commit it (it lands on the PR branch). Then
click **Resolve conversation** under the thread. Pull the branch locally if you keep working on it.
---
Terminal-only route: create the review through the API (`line` = line number in the new file):

````
gh api repos/{owner}/{repo}/pulls/<N>/reviews --input - <<'EOF'
{"event": "COMMENT", "body": "One fix against the spec",
 "comments": [{"path": "src/shipping.js", "line": 6, "side": "RIGHT",
   "body": "Spec says >= $50.\n```suggestion\n  if (total >= FREE_SHIPPING_FROM) return 0;\n```"}]}
EOF
````
then apply it locally (`gh pr checkout <N>`, edit, commit, push) and resolve the thread in the web UI.
