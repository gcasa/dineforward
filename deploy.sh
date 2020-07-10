#!/bin/sh
ENV=${1:-dev}

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

./scripts/run.sh ${ENV}