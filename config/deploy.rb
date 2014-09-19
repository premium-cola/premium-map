require "bundler/vlad"

set :application, "hcking"
set :deploy_to, "/home/premiumc/premium"
set :user, "premiumc"
set :domain, "#{user}@cygnus.uberspace.de"
set :repository, 'git@bitbucket.org:bitboxer/premium-cola.git'

set :config_files, ['database.yml', 'initializers/secret_token.rb']

namespace :vlad do

  desc "Copy config files from shared/config to release dir"
  remote_task :copy_config_files, :roles => :app do
    config_files.each do |filename|
      run "cp #{shared_path}/config/#{filename} #{release_path}/config/#{filename}"
    end
  end

  desc "Regenerate assets"
  remote_task :regenerate_assets, :roles => :app do
    run "cd #{release_path};RAILS_ENV=production bundle exec rake assets:precompile"
  end

  desc "Make a call to the passenger to create a running instance"
  remote_task :call_passenger, :roles => :app do
    run "wget -O /tmp/bla.html http://premiumc.cygnus.uberspace.de"
  end

end
