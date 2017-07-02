namespace :regions do
  desc 'Load regions from YAML with deleting old data'
  task load: :environment do
    file_path = "#{Rails.root}/tmp/import/regions.yml"
    media_dir = "#{Rails.root}/tmp/import/regions"
    ignored   = %w(image header_image)
    if File.exists? file_path
      puts 'Deleting old regions...'
      Region.destroy_all
      puts 'Done. Importing...'
      File.open file_path, 'r' do |file|
        YAML.load(file).each do |id, data|
          attributes = data.reject { |key| ignored.include?(key) }
          entity     = Region.new id: id
          entity.assign_attributes(attributes)
          if data.key?('image')
            image_file = "#{media_dir}/image/#{id}/#{data['image']}"
            if File.exists?(image_file)
              entity.image = Pathname.new(image_file).open
            end
          end
          if data.key?('header_image')
            image_file = "#{media_dir}/header_image/#{id}/#{data['header_image']}"
            if File.exists?(image_file)
              entity.header_image = Pathname.new(image_file).open
            end
          end
          entity.save!
          print "\r#{id}    "
        end
        puts
      end
      Region.connection.execute "select setval('regions_id_seq', (select max(id) from regions));"
      puts "Done. We have #{Region.count} regions now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Dump regions to YAML'
  task dump: :environment do
    file_path = "#{Rails.root}/tmp/export/regions.yml"
    media_dir = "#{Rails.root}/tmp/export/regions"
    ignored   = %w(id users_count image header_image)
    File.open file_path, 'w' do |file|
      Region.order('id asc').each do |entity|
        print "\r#{entity.id}    "
        file.puts "#{entity.id}:"
        entity.attributes.reject { |a, v| ignored.include?(a) || v.nil? }.each do |attribute, value|
          file.puts "  #{attribute}: #{value.inspect}"
        end
        unless entity.image.blank?
          image_name = "#{entity.long_slug}#{File.extension(File.basename(entity.image.path))}"
          image_dir  = "#{media_dir}/image/#{entity.id}"
          FileUtils.mkdir_p(image_dir) unless Dir.exists?(image_dir)
          FileUtils.copy(entity.image.path, "#{image_dir}/#{image_name}")
          file.puts "  image: #{image_name.inspect}"
        end
        unless entity.header_image.blank?
          image_name = "#{entity.long_slug}#{File.extension(File.basename(entity.header_image.path))}"
          image_dir  = "#{media_dir}/header_image/#{entity.id}"
          FileUtils.mkdir_p(image_dir) unless Dir.exists?(image_dir)
          FileUtils.copy(entity.header_image.path, "#{image_dir}/#{image_name}")
          file.puts "  header_image: #{image_name.inspect}"
        end
      end
      puts
    end
  end
end
