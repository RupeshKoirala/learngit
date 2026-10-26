# A folder of project files that is NOT a Git repository yet. The learner turns it into one.
mkdir -p shop
cd shop
brightcart_skeleton
rm -f .gitignore                      # writing the ignore file is part of the task
write package.json '{' '  "name": "brightcart-storefront",' '  "version": "0.1.0",' '  "private": true,' '  "scripts": { "test": "./test.sh" }' '}'
write .env.example "# Copy to .env and fill in real values. Never commit .env." "PAYMENT_API_KEY=" "DATABASE_URL="
# Things that must never end up in the repository:
write node_modules/left-pad/index.js "module.exports = (s, n) => String(s).padStart(n);"
write node_modules/left-pad/package.json '{ "name": "left-pad", "version": "1.3.0" }'
write .env "PAYMENT_API_KEY=pretend-this-is-a-real-live-key" "DATABASE_URL=postgres://admin:hunter2@localhost/brightcart"
write npm-debug.log "0 info it worked if it ends with ok" "1 verbose cli [ 'node', 'npm', 'install' ]" "2 error code ENOENT"
