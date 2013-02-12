namespace :sync do
  
  desc "Mirrors the remote shared public directory with your local copy, doesn't download symlinks"
  task :shared_assets, :roles => :shared_host do
    # Used friendly options so it's easier to read
    # I'm using rsync so that it only copies what it needs
    # Windows users you can use the download method within capistrano and pass recursive =&gt; true
    run_locally("rsync --recursive --times --rsh=ssh --compress --human-readable --progress #{user}@#{shared_host}:#{shared_path}/system/ public/system")
  end
  
  desc "Load production data into development database"
  task :database, :roles => :db, :only => { :primary => true } do
    require 'yaml'
    
    # Gets db yml from server, because we don't store it on dev boxes!
    get "#{current_path}/config/database.yml", "tmp/prod_database.yml"
    prod_config = YAML::load_file('tmp/prod_database.yml')
    local_config = YAML::load_file('config/database.yml')
    
    # Dump server sql
    filename = "dump.#{Time.now.strftime '%Y-%m-%d_%H:%M:%S'}.sql.gz"
    server_dump_file = "#{current_path}/tmp/#{filename}"
    on_rollback { delete server_dump_file }
    run "mysqldump -h #{prod_config['production']['host']} -u #{prod_config['production']['username']} --password=#{prod_config['production']['password']} #{prod_config['production']['database']} | gzip > #{server_dump_file}" do |channel, stream, data|
      puts data
    end
    
    get "#{server_dump_file}", "tmp/#{filename}"
    
    puts "Uncompressing & loading locally..."
    `gunzip < tmp/#{filename} | mysql -u #{local_config['development']['username']} --password=#{local_config['development']['password']} #{local_config['development']['database']}`
    puts "Cleaning up temp files"
    `rm -f tmp/#{filename}`
    `rm -f tmp/prod_database.yml`
  end
end
