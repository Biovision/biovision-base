namespace :tokens do
  desc 'Load tokens from YAML with deleting old data'
  task load: :environment do
    file_path = "#{Rails.root}/tmp/import/tokens.yml"
    ignored   = %w(agent)
    if File.exist?(file_path)
      puts 'Deleting old tokens...'
      Token.destroy_all
      puts 'Done. Importing...'
      File.open(file_path, 'r') do |file|
        YAML.load(file).each do |id, data|
          attributes = data.reject { |key| ignored.include? key }
          entity     = Token.new(id: id)
          entity.assign_attributes(attributes)

          if data.key?('agent')
            entity.agent = Agent.named(data['agent'])
          end
          entity.save!

          print "\r#{id}    "
        end
        puts
      end
      Token.connection.execute "select setval('tokens_id_seq', (select max(id) from tokens));"
      puts "Done. We have #{Token.count} tokens now"
    else
      puts "Cannot find file #{file_path}"
    end
  end

  desc 'Dump tokens to YAML'
  task dump: :environment do
    file_path = "#{Rails.root}/tmp/export/tokens.yml"
    ignored   = %w(id ip agent_id)
    File.open file_path, 'w' do |file|
      Token.order('id asc').each do |entity|
        print "\r#{entity.id}    "
        file.puts "#{entity.id}:"
        entity.attributes.reject { |a, v| ignored.include?(a) || v.nil? }.each do |attribute, value|
          file.puts "  #{attribute}: #{value.inspect}"
        end
        file.puts "  agent: #{entity.agent.name.inspect}" unless entity.agent.nil?
        file.puts "  ip: #{entity.ip}" unless entity.ip.blank?
      end
      puts
    end
  end

  desc 'Clean obsolete tokens'
  task clean: :environment do
    CleanTokensJob.perform_now
  end
end
