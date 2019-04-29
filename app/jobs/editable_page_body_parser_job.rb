# frozen_string_literal: true

# Parse editable page body
class EditablePageBodyParserJob < ApplicationJob
  queue_as :default

  # @param [Integer] id
  def perform(id)
    entity = EditablePage.find_by(id: id)

    return if entity.nil?

    entity.parsed_body = OembedReceiver.convert(entity.body)
    entity.save
  end
end
