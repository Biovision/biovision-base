# frozen_string_literal: true

# Adds UUID field and constraints to model
module HasUuid
  extend ActiveSupport::Concern

  included do
    after_initialize { self.uuid = SecureRandom.uuid if uuid.nil? }
    validates_presence_of :uuid
    validates_uniqueness_of :uuid
  end
end
