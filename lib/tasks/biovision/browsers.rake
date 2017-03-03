namespace :browsers do
  desc 'Load browsers from YAML with deleting old data'
  task load: :environment do
    file_path = "#{Rails.root}/tmp/import/browsers.yml"
    if File.exists? file_path
      puts 'Deleting old browsers...'
      Browser.destroy_all
      puts 'Done. Importing...'
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          browser = Browser.new id: id
          browser.assign_attributes data
          browser.save!
          print "\r#{id}    "
        end
        puts
      end
      Browser.connection.execute "select setval('browsers_id_seq', (select max(id) from browsers));"
      puts "Done. We have #{Browser.count} browsers now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Dump browsers to YAML'
  task dump: :environment do
    file_path = "#{Rails.root}/tmp/export/browsers.yml"
    ignored   = %w(id agents_count)
    File.open file_path, 'w' do |file|
      Browser.order('id asc').each do |entity|
        file.puts "#{entity.id}:"
        entity.attributes.reject { |a, v| ignored.include?(a) || v.nil? }.each do |attribute, value|
          file.puts "  #{attribute}: #{value.inspect}"
        end
      end
    end
  end
end
