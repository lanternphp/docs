#!/usr/bin/env sh

# abort on errors
set -e

# move to root
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# remove previous build dir
rm -rf .vuepress

# build
npm run build

# navigate into the build output directory
cd .vuepress/

git init -b master
git add -A
git commit -m 'rebuild docs from https://github.com/lanternphp/docs'

git push -f git@github.com:lanternphp/lanternphp.github.io.git master

cd -
