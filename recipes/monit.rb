require 'erb'

# We use monit to manage backgroundrb on the server.
# These tasks enable us to start/stop/restart them.
namespace :monit do
  desc "Stop monit"
  task :stop, :roles => [:app] do
    sudo "/usr/bin/monit -g #{application} stop all"
    sudo "/etc/init.d/monit stop"
  end

  desc "Start monit"
  task :start, :roles => [:app] do
    sudo "/etc/init.d/monit start"
    sudo "/usr/bin/monit -g #{application} start all"
  end

  desc "Restart monit"
  task :restart, :roles => [:app] do
    stop
    run  "sleep 2"
    start
  end
  
  desc "Uploads monit configuration file as /etc/monit/(application name)"
  task :upload_config, :roles => [:app] do
    conf_dir = "/etc/monit/conf"
    monit_conf = ERB.new(
      File.read("./config/deploy/monit.erb")
    ).result(binding)
    put monit_conf, "#{application}_monit.conf"
    sudo "mv #{application}_monit.conf #{conf_dir}/#{application}"
    sudo "chown root:root #{conf_dir}/#{application}"
  end
end