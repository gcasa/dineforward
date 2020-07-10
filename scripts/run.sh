#!/bin/sh

export DOTENV=~/Development/dineforward/env.dev

echo "Starting services..."
brew services stop mongodb-community@4.2
sleep 1
brew services start mongodb-community@4.2
sleep 1

echo "Starting dineforward"
yarn
yarn dev

echo "Exiting"
exit 0