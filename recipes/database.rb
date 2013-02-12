require 'erb'

after "deploy:setup", :db
after "deploy:update_code", "db:symlink" 

namespace :db do
  desc "Create database yaml in shared path" 
  task :default, :roles => :app do
    db_config = ERB.new <<-EOF
    base: &base
      adapter: mysql
      username: root
      password: 
      host: localhost
      encoding: utf8
      pool: 10

    development:
      database: #{application}_development
      <<: *base

    test:
      database: #{application}_test
      <<: *base

    production:
      database: #{application}_production
      <<: *base
    EOF

    run "mkdir -p #{shared_path}/config" 
    put db_config.result, "#{shared_path}/config/database.yml"
    run "chmod 600 #{shared_path}/config/database.yml"
  end

  desc "Make symlink for database yaml" 
  task :symlink, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end
end