set :user, 'admin'
set :domain, '192.168.8.201'
set :application, 'miamir'
set :repository,  'git://207.97.227.239/archiechen/miamir.git'
set :deploy_to, '/home/admin/miamir'
set :scm, 'git'
set :branch, 'master'
set :keep_releases, 5
set :rails_env, 'production'
set :use_sudo, false
role :web, domain
role :app, domain
role :db,  domain

namespace :deploy do
  desc 'restart thin'
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{release_path} && bundle install --deployment &&
      rake RAILS_ENV=production db:migrate &&
      rake assets:precompile

      thin stop -p #{deploy_to}/shared/pids/thin.pid &&
      thin -e production start -p 8080  -d"
  end
end
