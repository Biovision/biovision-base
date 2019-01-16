require 'fileutils'

namespace :users do
  desc 'Load users from YAML with deleting old data'
  task load: :environment do
    file_path = "#{Rails.root}/tmp/import/users.yml"
    media_dir = "#{Rails.root}/tmp/import/users"
    ignored   = %w(image agent)
    if File.exist?(file_path)
      puts 'Deleting old users...'
      User.destroy_all
      puts 'Done. Importing...'
      File.open(file_path, 'r') do |file|
        YAML.load(file).each do |id, data|
          attributes = data.reject { |key| ignored.include? key }
          entity     = User.new(id: id)
          entity.assign_attributes(attributes)
          if data.key?('image')
            image_file = "#{media_dir}/#{id}/#{data['image']}"
            if File.exist?(image_file)
              entity.image = Pathname.new(image_file).open
            end
          end
          if data.key?('agent')
            entity.agent = Agent.named(data['agent'])
          end
          entity.save!

          print "\r#{id}    "
        end
        puts
      end
      User.connection.execute "select setval('users_id_seq', (select max(id) from users));"
      puts "Done. We have #{User.count} users now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Dump users to YAML'
  task dump: :environment do
    file_path = "#{Rails.root}/tmp/export/users.yml"
    media_dir = "#{Rails.root}/tmp/export/users"
    ignored   = %w[id image ip agent_id data follower_count followee_count comments_count]
    Dir.mkdir(media_dir) unless Dir.exist?(media_dir)
    File.open(file_path, 'w') do |file|
      User.order('id asc').each do |entity|
        print "\r#{entity.id}    "
        file.puts "#{entity.id}:"
        entity.attributes.reject { |a, v| ignored.include?(a) || v.nil? }.each do |attribute, value|
          file.puts "  #{attribute}: #{value.inspect}"
        end

        unless entity.image.blank?
          image_name = File.basename(entity.image.path)
          Dir.mkdir("#{media_dir}/#{entity.id}") unless Dir.exist?("#{media_dir}/#{entity.id}")
          FileUtils.copy(entity.image.path, "#{media_dir}/#{entity.id}/#{image_name}")
          file.puts "  image: #{image_name.inspect}"
        end

        file.puts "  agent: #{entity.agent.name.inspect}" unless entity.agent.nil?
        file.puts "  ip: #{entity.ip}" unless entity.ip.blank?

        next if entity.data.blank?

        file.puts '  data:'
        entity.data.each do |data_key, data_values|
          next if data_values.nil?

          if data_values.is_a?(Enumerable)
            file.puts "    #{data_key}:"
            data_values.each do |k, v|
              next if v.nil?

              file.puts "      #{k}: #{v.inspect}"
            end
          else
            file.puts "    #{data_key}: #{data_values.inspect}"
          end
        end
      end
      puts
    end
  end
end
