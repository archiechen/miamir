set :user, 'root'
set :domain, '106.187.95.9'
set :application, 'miamir'
set :repository,  'git://github.com/archiechen/miamir.git'
set :deploy_to, '/apps/miamir'
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
    run "cd #{release_path} && bundle install &&
      cp #{deploy_to}/shared/config/*.yml config/ &&
      rake RAILS_ENV=production db:migrate &&
      rake assets:precompile &&
      thin stop &&
      bundle exec thin -e production start -p 80 -d"
  end
end
