# frozen_string_literal: true

# Add users and content components if they do not exist
class AddComponents < ActiveRecord::Migration[5.2]
  def up
    %w[users content].each do |slug|
      BiovisionComponent.create(slug: slug)
    end

    copy_contact_parameters
  end

  def down
    # No rollback needed
  end

  private

  def copy_contact_parameters
    component = BiovisionComponent['contact']

    return unless component.settings['feedback_receiver'].blank?

    component.settings['feedback_receiver'] = component.get('feedback_receiver')
    component.save
  end
end
