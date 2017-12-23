class AmendForeignKeys < ActiveRecord::Migration[5.1]
  def up
    correct_data = {
      metric_values:              {
        metrics: { on_update: :cascade, on_delete: :cascade }
      },
      agents:                     {
        browsers: { on_update: :cascade, on_delete: :cascade }
      },
      users:                      {
        regions: { on_update: :cascade, on_delete: :nullify },
        agents:  { on_update: :cascade, on_delete: :nullify }
      },
      user_profiles:              {
        users: { on_update: :cascade, on_delete: :cascade }
      },
      tokens:                     {
        users:  { on_update: :cascade, on_delete: :cascade },
        agents: { on_update: :cascade, on_delete: :nullify }
      },
      codes:                      {
        code_types: { on_update: :cascade, on_delete: :cascade },
        users:      { on_update: :cascade, on_delete: :cascade },
        agents:     { on_update: :cascade, on_delete: :nullify }
      },
      user_privileges:            {
        regions:    { on_update: :cascade, on_delete: :cascade },
        users:      { on_update: :cascade, on_delete: :cascade },
        privileges: { on_update: :cascade, on_delete: :cascade }
      },
      privilege_group_privileges: {
        privilege_groups: { on_update: :cascade, on_delete: :cascade },
        privileges:       { on_update: :cascade, on_delete: :cascade }
      },
      foreign_users:              {
        foreign_sites: { on_update: :cascade, on_delete: :cascade },
        users:         { on_update: :cascade, on_delete: :cascade },
        agents:        { on_update: :cascade, on_delete: :nullify }
      },
      login_attempts:             {
        users:  { on_update: :cascade, on_delete: :cascade },
        agents: { on_update: :cascade, on_delete: :nullify }
      },
      media_folders:              {
        users:  { on_update: :cascade, on_delete: :nullify },
        agents: { on_update: :cascade, on_delete: :nullify }
      },
      media_files:                {
        media_folders: { on_update: :cascade, on_delete: :nullify },
        users:         { on_update: :cascade, on_delete: :nullify },
        agents:        { on_update: :cascade, on_delete: :nullify }
      },
      feedback_requests:          {
        agents: { on_update: :cascade, on_delete: :nullify }
      }
    }

    correct_data.each do |table_name, links|
      foreign_keys(table_name).each do |current_key|
        reference = current_key.to_table.to_sym
        next unless links.key?(reference)
        next unless current_key.options[:on_delete].nil?
        remove_foreign_key(table_name, reference)
        add_foreign_key(table_name, reference, links[reference])
      end
    end
  end

  def down
    # keys should remain correct
  end
end
