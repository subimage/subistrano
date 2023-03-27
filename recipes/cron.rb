require 'erb'

namespace :cron do
  
  desc "Updates CRON maintenance task on primary app server. Looks for file in ./config/deploy/crontab.erb"
  task :upload_config, :roles => [:app], :only => { :primary => true } do
    # If there's no crontab an exception will be thrown
    begin
      current_cron = capture "crontab -l"
    rescue Exception
      current_cron = ""
    end
    
    str_cron_begin = "# begin #{application}"
    str_cron_end   = "# end #{application}"
    
    app_cron = ""
    app_cron << str_cron_begin
    app_cron << ERB.new(
      File.read("./config/deploy/crontab.erb")
    ).result(binding)
    app_cron << str_cron_end
    
    if current_cron.index(str_cron_begin)
      new_cron = current_cron.gsub(
        /^#{str_cron_begin}.*#{str_cron_end}$/m,
        app_cron
      )
    else
      new_cron = current_cron << app_cron
    end
    
    # Upload edited crontab & install on server
    put new_cron, 'crontab.new'
    run 'crontab crontab.new'
  end
  
end