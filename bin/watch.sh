#!/usr/bin/env sh

# abort on errors
set -e

# move to root
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# watch
yarn dev
