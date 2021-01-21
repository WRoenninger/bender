#!/bin/bash
set -e

cd "$(dirname "${BASH_SOURCE[0]}")"
BENDER="cargo run --"
DIR="$(pwd)"/tmp/"$(basename $0 _test.sh)"
[ ! -d "$DIR" ] || rm -rf "$DIR"
mkdir -p "$DIR"
cd "$DIR"

mkdir foo
mkdir bar

cd "$DIR"/foo
git init
git config --local user.name 'Nobody'
git config --local user.email 'nobody@localhost'
touch README
git add .
git commit -m "Hello"

readonly BRANCH=$(git branch --show-current)

cd "$DIR"/bar
echo "
package:
  name: bar

dependencies:
  foo: { git: \"file://$DIR/foo\", rev: $BRANCH }
" > Bender.yml
$BENDER path foo # this fails according to issue #5
