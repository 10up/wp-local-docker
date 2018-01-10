#!/bin/bash
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)

THEME="genesis-starter"

echo " * Installing Composer dependencies..."
composer install

echo " * Installing NPM dependencies..."
npm install

echo " * Building theme..."
cd "$ROOT/wp-content/themes/$THEME"
composer install
npm install
npm run build
