#!/bin/sh

ENV=${1:-dev}

export DOTENV=~/Development/dineforward/env.${ENV}
. ./deploy_${ENV}.cfg

echo "Starting services..."
brew services stop mongodb-community@4.2
sleep 1
brew services start mongodb-community@4.2
sleep 1

echo "Starting dineforward"
yarn
yarn ${ENV}

echo "Exiting"
exit 0