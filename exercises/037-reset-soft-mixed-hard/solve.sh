cd repo
git reset -q -- notes.txt
git restore src/price.js
git reset -q --soft HEAD~3
git commit -q -m "Add free shipping threshold"
echo hard > ../ANSWER
