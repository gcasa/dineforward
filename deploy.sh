#!/bin/sh
ENV=${1:-dev}

echo "Generating configuration files..."
. ./deploy_${ENV}.cfg

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
    "@babel/cli": "^7.8.4",
    "@babel/core": "^7.8.6",
    "@babel/node": "^7.8.4",
    "@babel/plugin-proposal-class-properties": "^7.8.3",
    "@babel/plugin-proposal-object-rest-spread": "^7.8.3",
    "@babel/plugin-transform-object-assign": "^7.8.3",
    "@babel/plugin-transform-react-constant-elements": "^7.8.3",
    "@babel/plugin-transform-runtime": "^7.8.3",
    "@babel/preset-env": "^7.8.6",
    "@babel/preset-react": "^7.8.3",
    "@babel/register": "^7.8.6",
    "@types/lodash": "^4.14.138",
    "@types/mocha": "^7.0.1",
    "@types/prettier": "^1.18.0",
    "@types/react": "^16.9.3",
    "@types/sinon": "^7.0.13",
    "babel-core": "^7.0.0-bridge.0",
    "babel-eslint": "^10.0.3",
    "babel-loader": "^8.0.0",
    "babel-plugin-module-resolver": "^4.0.0",
    "babel-plugin-optimize-clsx": "^2.3.0",
    "babel-plugin-react-remove-properties": "^0.3.0",
    "babel-plugin-tester": "^8.0.0",
    "babel-plugin-transform-dev-warning": "^0.1.0",
    "babel-plugin-transform-react-remove-prop-types": "^0.4.21",
    "broken-link-checker": "^0.7.8",
    "compression-webpack-plugin": "^3.0.0",
    "concurrently": "^5.1.0",
    "confusing-browser-globals": "^1.0.9",
    "core-js": "^2.6.11",
    "cross-env": "^7.0.0",
    "eslint": "^5.9.0",
    "eslint-config-airbnb": "^18.1.0",
    "eslint-config-prettier": "^6.2.0",
    "eslint-import-resolver-webpack": "^0.12.0",
    "eslint-plugin-babel": "^5.3.0",
    "eslint-plugin-import": "^2.18.2",
    "eslint-plugin-jsx-a11y": "^6.2.3",
    "eslint-plugin-mocha": "^6.1.1",
    "eslint-plugin-prettier": "^3.1.2",
    "eslint-plugin-react": "^7.14.3",
    "eslint-plugin-react-hooks": "^2.1.1",
    "format-util": "^1.0.5",
    "fs-extra": "^8.1.0",
    "glob": "^7.1.2",
    "glob-gitignore": "^1.0.11",
    "husky": "^4.2.3",
    "lerna": "^3.20.2",
    "lodash": "^4.17.15",
    "node-fetch": "^ 2.6.0",
    "prettier": "1.17.0",
    "pretty-bytes": "^5.3.0",
    "pretty-format-v24": "npm:pretty-format@24",
    "prop-types": "^15.7.2",
    "rimraf": "^3.0.0",
    "run-node": "^2.0.0",
    "sort-package-json": "^1.36.0",
    "vrtest-mui": "^0.3.3",
    "webpack": "^4.41.0",
    "webpack-cli": "^3.3.9",
    "yargs": "^15.2.0",
    "yarn-deduplicate": "^2.0.0"
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
    "arg": "^4.1.3",
    "chalk": "^3.0.0",
    "ci-info": "^2.0.0",
    "cross-env": "^7.0.0",
    "dev-null": "^0.1.1",
    "endent": "^1.4.1",
    "express": "^4.17.1",
    "express-session": "^1.17.0",
    "fs-extra": "^9.0.0",
    "globby": "^11.0.0",
    "ora": "^4.0.3",
    "terminal-link": "^2.1.1"
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
    "dotenv": "^8.2.0",
    "expand-template": "^2.0.3"
  },
  "devDependencies": {
  }
}
!EOF2
echo "Done creating config..."

sleep 1

./scripts/run.sh ${ENV}