# This is a sample Capistrano config file for rubber

set :rails_env, RUBBER_ENV

on :load do
  set :application, rubber_env.app_name
  set :runner,      rubber_env.app_user
  set :deploy_to,   "/mnt/#{application}-#{RUBBER_ENV}"
  set :copy_exclude, [".git/*", ".bundle/*", "log/*", ".rvmrc"]
end

# Use a simple directory tree copy here to make demo easier.
# You probably want to use your own repository for a real app
set :scm, :none
set :repository, "."
set :deploy_via, :copy

# Easier to do system level config as root - probably should do it through
# sudo in the future.  We use ssh keys for access, so no passwd needed
set :user, 'root'
set :password, nil

# Use sudo with user rails for cap deploy:[stop|start|restart]
# This way exposed services (mongrel) aren't running as a privileged user
set :use_sudo, true

# How many old releases should be kept around when running "cleanup" task
set :keep_releases, 3

# Lets us work with staging instances without having to checkin config files
# (instance*.yml + rubber*.yml) for a deploy.  This gives us the
# convenience of not having to checkin files for staging, as well as 
# the safety of forcing it to be checked in for production.
set :push_instance_config, RUBBER_ENV != 'production'

# Allows the tasks defined to fail gracefully if there are no hosts for them.
# Comment out or use "required_task" for default cap behavior of a hard failure
rubber.allow_optional_tasks(self)
# Wrap tasks in the deploy namespace that have roles so that we can use FILTER
# with something like a deploy:cold which tries to run deploy:migrate but can't
# because we filtered out the :db role
namespace :deploy do
  # desc "precompile and deploy the assets to the server" 
  # after "deploy:update_code", "deploy:precompile_assets" 
  # task :precompile_assets, :roles => :app do 
  #   run_locally "#{rake} RAILS_ENV=#{rails_env} RAILS_GROUPS=assets assets:precompile" 
  #   transfer(:up, "public/assets", "#{release_path}/public/assets") { print "." } 
  #   run_locally "rm -rf public/assets"    # clean up to avoid conflicts with development-mode assets 
  # end 

  rubber.allow_optional_tasks(self)
  tasks.values.each do |t|
    if t.options[:roles]
      task t.name, t.options, &t.body
    end
  end
end

# load in the deploy scripts installed by vulcanize for each rubber module
Dir["#{File.dirname(__FILE__)}/rubber/deploy-*.rb"].each do |deploy_file|
  load deploy_file
end

before "rubber:pre_start", "setup_app_permissions" 
before "rubber:pre_restart", "setup_app_permissions" 
task :setup_app_permissions do 
  run "chown -R #{rubber_env.app_user}:#{rubber_env.app_user} #{current_path}/public" 
end 

after "deploy", "deploy:cleanup"
