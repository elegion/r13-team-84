#############################################
##                                         ##
##              Configuration              ##
##                                         ##
#############################################
require "bundler/capistrano"

GITHUB_REPOSITORY_NAME = 'r13-team-84'
LINODE_SERVER_HOSTNAME = '74.207.250.151'

#############################################
#############################################

# General Options

set :bundle_flags,               "--deployment"

set :application,                "railsrumble"
set :deploy_to,                  "/var/www/apps/railsrumble"
set :normalize_asset_timestamps, false
set :rails_env,                  "production"

set :user,                       "root"
set :runner,                     "www-data"
set :admin_runner,               "www-data"

# SCM Options
#set :scm,        :git
#set :repository, "git@github.com:railsrumble/#{GITHUB_REPOSITORY_NAME}.git"
#set :deploy_via ,:remote_cache
#set :branch,     'master'
set :scm,        :none
set :repository, "./"
set :deploy_via ,:copy
set :branch,     'master'

# Roles
role :app, LINODE_SERVER_HOSTNAME
role :db,  LINODE_SERVER_HOSTNAME, :primary => true
role :web, LINODE_SERVER_HOSTNAME

set :shared_children,   %w(public/system log tmp/pids tmp/sockets)
# Add Configuration Files & Compile Assets
after 'deploy:update_code' do
  # Setup Configuration
  run "cp #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end

namespace :deploy do
  desc "Start the Thin processes"
  task :start do
    run  %{
      cd #{current_path};
      bundle exec thin start -C config/thin.yml;
      bundle exec rake rooms_deamon:start RAILS_ENV=production
    }
  end

  desc "Stop the Thin processes"
  task :stop do
    run %{
      cd #{current_path};
      bundle exec thin stop -C config/thin.yml;
      bundle exec rake rooms_deamon:stop RAILS_ENV=production
    }
  end

  desc "Restart the Thin processes"
  task :restart do
    run %{
      cd #{current_path};
      bundle exec thin restart -C config/thin.yml;
      bundle exec rake rooms_deamon:stop RAILS_ENV=production;
      bundle exec rake rooms_deamon:start RAILS_ENV=production
    }
  end

  #desc "Create a symlink from the public/cvs folder to the shared/system/cvs folder"
  #task :update_cv_assets, :except => {:no_release => true} do
  #  run <<-CMD
  #    ln -s /var/www/shared/cvs /var/www/apps/current/public
  #  CMD
  #end
end
