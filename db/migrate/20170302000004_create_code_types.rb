class CreateCodeTypes < ActiveRecord::Migration[5.1]
  def up
    unless CodeType.table_exists?
      create_table :code_types do |t|
        t.string :slug, null: false
        t.string :name, null: false
      end

      CodeType.create(slug: 'confirmation', name: 'Подтверждение почты')
      CodeType.create(slug: 'recovery', name: 'Сброс пароля')
      CodeType.create(slug: 'invitation', name: 'Приглашение')
    end
  end

  def down
    if CodeType.table_exists?
      drop_table :code_types
    end
  end
end
