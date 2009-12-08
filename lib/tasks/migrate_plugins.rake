namespace :db do
  desc 'Migrates installed plugins.'
  task :migrate_plugins => :environment do
    if Rails.respond_to?('plugins')
      Rails.plugins.each do |plugin|
        next unless plugin.respond_to?('migrate')
        puts "Migrating #{plugin.name}..."
        plugin.migrate
      end
    else
      puts "Undefined method plugins for Rails!"
      puts "Make sure engines plugin is installed."
    end
  end
  
  desc 'Migrate a specified plugin.'
  task :migrate_plugin => :environment do
    if ENV['NAME'].blank?
      puts "Please give a plugin name with NAME=my_plugin"
      exit
    end
    name = ENV['NAME']
    version = ENV['VERSION']
    if plugin = Rails.plugins[name]
      puts "Migrating #{plugin.name} to " + (version ? "version #{version}" : 'latest version') + "..."
      plugin.migrate(version ? version.to_i : nil)
    else
      puts "Plugin #{name} does not exist."
    end
  end
end