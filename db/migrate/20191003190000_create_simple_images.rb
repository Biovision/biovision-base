# frozen_string_literal: true

# Create tables for simple images
class CreateSimpleImages < ActiveRecord::Migration[5.2]
  def up
    create_simple_images unless SimpleImage.table_exists?
    create_simple_image_tags unless SimpleImageTag.table_exists?
    create_simple_image_tag_images unless SimpleImageTagImage.table_exists?
  end

  def down
    drop_table :simple_image_tag_images if SimpleImageTagImage.table_exists?
    drop_table :simple_image_tags if SimpleImageTag.table_exists?
    drop_table :simple_images if SimpleImage.table_exists?
  end

  private

  def create_simple_images
    create_table :simple_images, comment: 'Simple image' do |t|
      t.references :biovision_component, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :user, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.inet :ip
      t.uuid :uuid, null: false
      t.timestamps
      t.string :image
      t.string :image_alt_text
      t.string :caption
      t.string :source_name
      t.string :source_link
      t.jsonb :data, default: {}, null: false
    end
  end

  def create_simple_image_tags
    create_table :simple_image_tags, comment: 'Tag for tagging simple image' do |t|
      t.string :name, null: false, index: true
      t.timestamps
      t.integer :simple_images_count, default: 0, index: true, null: false
    end
  end

  def create_simple_image_tag_images
    create_table :simple_image_tag_images, comment: 'Link between simple image and tag' do |t|
      t.references :simple_image, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :simple_image_tag, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
    end
  end
end
