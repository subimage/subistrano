namespace :deploy do  
  # Renders custom maintenance page on the server.
  #
  # Implemented with help from:
  #   http://clarkware.com/cgi/blosxom/2007/01/05#CustomMaintenancePages
  namespace :web do
    desc "Disables the site by throwing a maintenance page up"
    task :disable, :roles => :web do
      #on_rollback { run "rm #{shared_path}/system/maintenance.html" }
      template = File.read("./public/maintenance.html")
      maintenance = ERB.new(template).result(binding)
      put maintenance, "#{shared_path}/system/maintenance.html", :mode => 0644
    end
    
    desc "Removes maint page"
    task :enable, :roles => :web do
      run "rm #{shared_path}/system/maintenance.html"
    end
  end

end