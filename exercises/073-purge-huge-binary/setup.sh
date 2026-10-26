# A 20 MB video was committed long ago, "deleted" later — but every clone still downloads it.
# junk <file> <MiB>: deterministic, incompressible bytes (an MD5 chain), same on every machine.
junk() { mkdir -p "$(dirname "$1")"; perl -MDigest::MD5=md5 -e 'binmode STDOUT; my $s="brightcart-promo"; for my $i (1..$ARGV[0]*65536) { $s = md5($s.$i); print $s }' "$2" > "$1"; }

new_bare remotes/origin.git
new_repo repo
brightcart_skeleton
as maya; commit "Initial storefront"
git remote add origin ../remotes/origin.git

as jo
mkdir -p assets; printf 'PNG-fake-hero-image\n' > assets/hero.png;
junk assets/promo-video.mov 20
write src/home.js "// Home page" "const hero = 'assets/hero.png';" "module.exports = { hero };"
commit "Add homepage hero"
as dev;  append src/cart.js "// cart v2 soon"; commit "Plan cart v2"
as jo;   git rm -q assets/promo-video.mov; commit "Remove promo video (served from CDN now)"
as lena; append src/home.js "// lazy-load the hero"; commit "Lazy-load hero image"
day
as maya; append README.md "" "Assets live in assets/. Videos go to the CDN."; commit "Document assets"
git switch -q -c feature/gift-cards
as dev;  write src/giftcards.js "// Gift cards" "module.exports = {};"; commit "Start gift cards"
git switch -q main
as you;  append src/price.js "// TODO: currency"; commit "Note currency TODO"
git push -q -u origin main feature/gift-cards

mkdir -p "$LG_DIR/.lg"
git ls-tree -r main | grep -v '	\.gitignore$' > "$LG_DIR/.lg/main.files"
