#!/bin/sh

export DOTENV=~/Development/dineforward/env.dev

echo "Starting services..."
brew services restart mongodb

echo "Starting dineforward"
yarn
yarn dev

echo "Exiting"
exit 0