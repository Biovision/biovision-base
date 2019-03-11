# frozen_string_literal: true

# Change JSON column types to JSONB in User, Code and Component
class ConvertJsonColumns < ActiveRecord::Migration[5.2]
  def up
    change_users if User.columns_hash['data'].type == :json
    change_codes if Code.columns_hash['data'].type == :json
    change_components if BiovisionComponent.columns_hash['settings'].type == :json
  end

  def down
    # No rollback needed
  end

  private

  def change_users
    queries = [
      %(alter table users alter column data set data type jsonb using data::jsonb),
      %(alter table users alter column data set default '{"profile":{}}'::jsonb)
    ]

    queries.each { |query| ActiveRecord::Base.connection.execute(query) }

    add_index :users, :data, using: :gin
  end

  def change_codes
    queries = [
      %(alter table codes alter column data set data type jsonb using data::jsonb),
      %(alter table codes alter column data set default '{}'::jsonb)
    ]

    queries.each { |query| ActiveRecord::Base.connection.execute(query) }

    add_index :codes, :data, using: :gin
  end

  def change_components
    queries = [
      %(alter table biovision_components alter column settings set data type jsonb using settings::jsonb),
      %(alter table biovision_components alter column settings set default '{}'::jsonb)
    ]

    queries.each { |query| ActiveRecord::Base.connection.execute(query) }
  end
end
