cd repo
git fetch -q --deepen=5
git fetch -q --unshallow
git blame -e -L '/FREE_SHIPPING_THRESHOLD/,+1' --porcelain src/shipping.js | sed -n 's/^author-mail <\(.*\)>$/\1/p' > ../ANSWER
cd ..
git clone -q --filter=blob:none "file://$PWD/remotes/origin.git" partial
