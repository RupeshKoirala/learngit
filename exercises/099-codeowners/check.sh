mkdir -p "$LG_DIR/.lg"
# A small CODEOWNERS evaluator: gitignore-style patterns, last matching line wins.
cat > "$LG_DIR/.lg/owners.pl" <<'PERL'
my ($file, $path) = @ARGV;
open(my $fh, '<', $file) or exit 2;
my $owners = '';
while (my $l = <$fh>) {
  $l =~ s/\r?\n$//; $l =~ s/^\s+//; next if $l eq '' || $l =~ /^#/;
  my @t = split /\s+/, $l; my $p = shift @t; my @o;
  for (@t) { last if /^#/; push @o, lc $_; }
  my $anch = ($p =~ s{^/}{}) ? 1 : 0;
  my $dir  = ($p =~ s{/$}{}) ? 1 : 0;
  $anch = 1 if $p =~ m{/};
  my $re = '';
  my @c = split //, $p;
  for (my $i = 0; $i < @c; $i++) {
    if ($c[$i] eq '*' && $i + 1 < @c && $c[$i+1] eq '*') {
      if ($i + 2 < @c && $c[$i+2] eq '/') { $re .= '(?:.*/)?'; $i += 2; } else { $re .= '.*'; $i++; }
    } elsif ($c[$i] eq '*') { $re .= '[^/]*'; }
    elsif ($c[$i] eq '?') { $re .= '[^/]'; }
    else { $re .= quotemeta $c[$i]; }
  }
  $re = ($anch ? '^' : '^(?:.*/)?') . $re . ($dir ? '/.*$' : '(?:/.*)?$');
  $owners = join(' ', sort @o) if $path =~ /$re/;
}
print "$owners\n";
PERL
CO="$LG_DIR/.lg/CODEOWNERS"
git -C "$LG_DIR/repo" show main:.github/CODEOWNERS > "$CO" 2>/dev/null || : > "$CO"
owns() {   # owns <path> <owners…>   the owners GitHub would request for <path>, order-insensitive
  _p="$1"; shift
  [ "$(perl "$LG_DIR/.lg/owners.pl" "$CO" "$_p")" = "$(printf '%s\n' "$@" | tr 'A-Z' 'a-z' | sort | tr '\n' ' ' | sed 's/ $//')" ]
}
valid_owners() {   # every rule line has at least one owner, and owners look like @user, @org/team or an email
  awk '!/^[ \t]*(#|$)/ { if (NF < 2) exit 1; for (i = 2; i <= NF; i++) { if ($i ~ /^#/) break;
       if ($i !~ /^@[A-Za-z0-9_-]+(\/[A-Za-z0-9_-]+)?$/ && $i !~ /@.*\./) exit 1 } }' "$CO"
}

in_repo
expect "you're on main"                                                    on_branch main
expect ".github/CODEOWNERS is committed on main"                           in_commit main .github/CODEOWNERS
expect "every rule has owners in @user / @org/team form"                   valid_owners
expect "README.md → @brightcart/maintainers (the default)"                 owns README.md @brightcart/maintainers
expect "src/README.md → @brightcart/maintainers (not in a src/ subfolder)" owns src/README.md @brightcart/maintainers
expect "src/checkout/cart.js → the checkout expert"                        owns src/checkout/cart.js @devpatel
expect "src/checkout/payments/stripe.js → checkout expert + security"      owns src/checkout/payments/stripe.js @devpatel @brightcart/security
expect "src/checkout/queries.sql → @brightcart/dba only (the .sql rule wins)" owns src/checkout/queries.sql @brightcart/dba
expect "src/catalog/list.js → the catalog expert (count people, not emails)" owns src/catalog/list.js @lenaokafor
expect "src/search/index.js → the search expert"                           owns src/search/index.js @jonovak
expect "infra/terraform/main.tf → @brightcart/platform"                    owns infra/terraform/main.tf @brightcart/platform
expect ".github/workflows/ci.yml → @brightcart/platform"                   owns .github/workflows/ci.yml @brightcart/platform
expect "docs/guide.md → @samrivera"                                        owns docs/guide.md @samrivera
expect "db/migrations/0042_add_giftcards.sql → @brightcart/dba"            owns db/migrations/0042_add_giftcards.sql @brightcart/dba
expect ".github/CODEOWNERS → @mayachen"                                    owns .github/CODEOWNERS @mayachen
expect "package.json → @brightcart/maintainers"                            owns package.json @brightcart/maintainers
expect "the working tree is clean"                                         clean_tree
finish
