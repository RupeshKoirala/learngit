# Write the release notes from conventional commits

Brightcart **v1.5.0** is tagged. Sam (PM) needs the release notes for the customer newsletter in an hour, and
the team writes [Conventional Commits](https://www.conventionalcommits.org) so you can generate them from Git
instead of from memory.

```
* feat(giftcards): sell gift cards                         <- main (after the release — not in 1.5.0!)
* fix(cart): coupon field accepts lowercase codes          (tag v1.5.0)
* feat(api): remove v1 price endpoint                      (body has a BREAKING CHANGE: footer)
* Merge pull request #43 from brightcart/wishlist-share
|\
| * feat(wishlist): share wishlist by link
|/
* chore(deps): update lodash
* ...                                                      (more PR merges, fixes and chores)
* fix(cart): cart badge shows the right count             (tag v1.4.0)
```

## Your task

Add a `## v1.5.0` section to `CHANGELOG.md`, **above** the existing `## v1.4.0` section, and commit it on `main`:

```markdown
## v1.5.0

### Features
- save cart between visits
...

### Fixes
- ...

### Breaking changes
- ...
```

Rules:
- Include exactly the commits **between v1.4.0 and v1.5.0**, nothing before or after.
- Each bullet is the commit's description: the subject **without** the `type(scope): ` prefix.
- `feat` → Features, `fix` → Fixes. Leave out **merge commits** and **chore** commits.
- **Breaking changes** lists every breaking commit — marked with `!` in the subject *or* with a
  `BREAKING CHANGE:` footer in the body. (They also stay in their Features/Fixes section.)
- Leave a clean working tree.

## You'll practice

Revision ranges (`v1.4.0..v1.5.0`), `git log --no-merges`, `--format`, `--grep` (and `-E`, `-i`, `--invert-grep`),
searching commit bodies, and turning Git history into something a PM can ship.
