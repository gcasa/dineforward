#!/bin/sh
ENV=${1:-dev}

echo "Generating configuration files..."
. ./deploy_${ENV}.cfg

general_dependencies=`cat ${dependencies_file}`
runner_dependencies=`cat ${runner_dependencies_file}`
config_dependencies=`cat ${config_dependencies_file}`

cat << !EOF0 > ./package.json
{
  "version": "${version}",
  "private": true,
  "name": "${app_name}",
  "description": "${app_desc}",
  "directories": {
    "test": "test"
  },
  "repository": {
    "type": "git",
    "url": "${git_url}"
  },
  "keywords": [
    "restaurants",
    "covid-19"
  ],
  "author": "${app_auth}",
  "license": "MIT",
  "bugs": {
    "url": "${bug_url}"
  },
  "resolutions": {
    "@babel/preset-env": "^7.8.7"
  },
  "homepage": "${homepage}",
  "scripts": {
    "build": "lerna run build --stream --no-prefix --scope=@dineforward/df-api --include-dependencies",
    "build:clean": "git clean -fdx packages -e packages/*/node_modules; yarn run build",
    "lint:fix": "eslint . --cache --fix",
    "prettier": "prettier --write \"./packages/**/*.{js,json,md,yml}\"",
    "test": "yarn lint && yarn typescript && yarn test:coverage",
    "bootstrap": "lerna bootstrap --use-workspaces",
    "clean": "./scripts/cleanup.sh && lerna clean && yarn cache clean",
    "dev": "lerna run dev --stream --no-prefix --scope=@dineforward/df-api --include-dependencies",
    "lint": "yarn lint:js && yarn lint:styles",
    "lint:js": "eslint . --ext .js --ignore-pattern lib --ignore-pattern node_modules --fix",
    "lint:styles": "stylelint './packages/**/*.js'",
    "list": "lerna list",
    "sort-pkg": "sort-package-json \"package.json\" \"packages/*/package.json\"",
    "start": "lerna run start --stream --no-prefix --scope=@dineforward/df-api --include-dependencies",
    "dock:up": "docker-compose up",
    "check-links": "./scripts/check-links.sh"
  },
  "dependencies": {
${general_dependencies}
  },
  "workspaces": [
    "packages/*"
  ]
}
!EOF0

cat << !EOF > ./deploy/config.js
const path = require("path");

const rootDir = path.dirname(__dirname);
const apiDir = path.join(rootDir, "packages", "${api_name}");
const clientDir = path.join(rootDir, "packages", "${client_name}");

const config = {
    apiDir,
    apiImage: "${api_image_name}",
    apiServiceBase: "${api_service_base}",
    clientDir,
    projectName: "${project_name}",
    region: "${region_name}",
    rootDir,
};

module.exports = config;
!EOF

cat << !EOF1 > ./packages/runner/package.json
{
  "name": "${runner_name}",
  "description": "${runner_description}",
  "private": ${private},
  "version": "${version}",
  "author": "${runner_author}",
  "repository": "${repository}",
  "homepage": "${homepage}",
  "license": "MIT",
  "engines": {
    "node": ">=10.0.0"
  },
  "scripts": {
  },
  "dependencies": {
${runner_dependencies}
  },
  "devDependencies": {}
}
!EOF1

cat << !EOF2 > ./packages/config/package.json
{
  "name": "${config_name}",
  "description": "${config_description}",
  "private": ${private},
  "version": "${version}",
  "author": "${config_author}",
  "repository": "${repository}",
  "homepage": "${homepage}",
  "license": "MIT",
  "engines": {
    "node": ">=10.0.0"
  },
  "scripts": {
  },
  "dependencies": {
${config_dependencies}
  },
  "devDependencies": {
  }
}
!EOF2
echo "Done creating config..."

sleep 1

./scripts/run.sh ${ENV}