Run plain `git commit` (no `-m`) — Git opens your editor. The first line is the subject, then an empty line,
then the body. Lines starting with `#` are comments and get stripped. (Editor not what you want?
`git config --global core.editor "code --wait"` or `"nano"`.)
---
A good subject completes the sentence *"If applied, this commit will …"*: "Prevent adding more items than
in stock" ✔ — "Added stock check." ✘. Count the characters: the subject must be ≤ 50.
---
Trailers are `Key: value` lines in the **last paragraph** of the message, separated from the body by a blank
line. Git parses them, so the format must be exact: `Closes #12` is GitHub-magic text and also fine, but
`Co-authored-by:` needs the colon and the `Name <email>` form.
---
A complete example (you can also pass it with `git commit -F msg.txt`, or build trailers with
`git commit --trailer "Co-authored-by: Lena Okafor <lena@brightcart.example>"`):

```
Prevent adding more items than in stock

Orders failed at payment when the cart held more units than the
warehouse had. Check stock when an item is added so customers see
the problem immediately instead of at checkout.

Closes #12
Co-authored-by: Lena Okafor <lena@brightcart.example>
```
Wrong message? `git commit --amend` (exercise 004).
