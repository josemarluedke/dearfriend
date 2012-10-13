require "bundler/capistrano"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true # Allows deploy use my ssh keys

# Application
set :application, "dear_friend" # Application name

# The addresses of servers involved in the deployment
role :web, "dear-friend.r12.railsrumble.com"
role :app, "dear-friend.r12.railsrumble.com"
role :db, "dear-friend.r12.railsrumble.com", :primary => true

# Repository informations
set :scm, :git
set :repository, "git@github.com:railsrumble/r12-team-537.git"
set :branch, 'master'

set :user, "deploy" # The deploy user
set :deploy_to, "/home/deploy/www/#{application}" # Makes deploy in this path

# Makes deploy be faster using a repository cache (in server)
set :deploy_via, :remote_cache

# For safety. Is not need to use sudo because :deploy_to can be written by :user
set :use_sudo, false

# Other options
set :git_enable_submodules, 1
set :scm_verbose, true

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end

  # Restart the application
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  # Copy the /home/deploy/database.yml to application path
  task :db_config, :roles => :app, :except => { :no_release => true } do
    run "cp -f ~/database.yml #{release_path}/config/database.yml"
  end
end

after "deploy:finalize_update", "deploy:db_config"
after "deploy", "deploy:migrate"
