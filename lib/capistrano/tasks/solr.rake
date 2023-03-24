namespace :solr do
  desc "execute updater script"
  task :update do
    #on roles(:app) do
    execute("bash #{current_path}/geoportal-core-updater.sh")
  end
end
