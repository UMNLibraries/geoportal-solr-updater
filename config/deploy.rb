# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"

set :application, "solr-core-update"
set :repo_url, "git@github.com:UMNLibraries/geoportal-solr-updater.git"

# set the git branch
set :branch, (ENV['BRANCH'] || 'main')

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/tmp/#{fetch(:application)}"

# Default value for :format is :airbrussh.
set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

# set the deploy user
set :deploy_user, "uldeploy"

# Default value for keep_releases is 5
set :keep_releases, 3
