# Container App

It is possible to configure this application to hold any node application.

* the file deploy_dev.cfg contains the parameterized variables to generate the configuration files needed to deploy.  The following config files are generated
  + package.json
  + packages/config/package.json
  + packages/runner/package.json
  
The configuration file takes the following parameters:

```
# config parameters

# deploy
api_name=df-api
client_name=df-client
api_image_name=${api_name}
api_service_base=${api_name}
project_name=dineforward
region_name=us-west1

# runner
runner_name="@dineforward/runner"
runner_description="Runner for DineForward"
runner_author="The world"
runner_dependencies_file=./config/runner_dependencies_file

# config
config_name="@dineforward/config"
config_description="Config for DineForward.org"
config_author="Mark Terrel"
config_dependencies_file=./config/config_dependencies_file

# general
private=true
version="0.0.1"
repository="https://github.com/gosignal/dineforward"
homepage="https://dineforward.org"
git_url="git+https://github.com/gosignal/dineforward.git"
app_name="@dineforward/app"
app_desc="Dine Forward - help support your favorite bar/restaurant/eatery -- anything in service of the public!"
app_auth="Signal Labs - and a bunch of badass mother f*kers donating their time"
bug_url="https://github.com/gosignal/dineforward/issues"
dependencies_file=./config/general_dependencies_file
```

The dependencies files are used to define the dependencies for each of the configuration files.

The application is started using deploy.sh.

