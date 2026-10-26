# Lena releases ui-kit v1.1.0, then starts on something unfinished on main.
cd "$LG_DIR/.team/ui-kit"
as lena
day
write VERSION "1.1.0"
write buttons.css ".btn { padding: 8px 16px; border-radius: 4px; }" ".btn:focus-visible { outline: 2px solid #2563eb; }"
commit "fix: visible focus ring on buttons"
write badge.css ".badge { font-size: 12px; padding: 2px 6px; border-radius: 999px; }"
commit "feat: badge component"
git tag -a v1.1.0 -m "UI kit 1.1.0"
write tokens-dark.css "/* WIP: dark mode tokens, do not use yet */"
commit "wip: dark mode tokens"
git push -q origin main --tags
