# frozen_string_literal: true

# User privileges in component
#
# Attributes:
#   administrator [Boolean]
#   biovision_component_id [BiovisionComponent]
#   created_at [DateTime]
#   data [Json]
#   updated_at [DateTime]
#   user_id [User]
class BiovisionComponentUser < ApplicationRecord
  belongs_to :biovision_component
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :biovision_component_id
end
