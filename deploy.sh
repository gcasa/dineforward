#!/bin/sh
ENV=${1:-dev}

echo "Generating configuration files..."
. ./deploy_${ENV}.cfg

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