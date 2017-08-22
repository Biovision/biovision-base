class UserProfile < ApplicationRecord
  NAME_LIMIT   = 100

  enum gender: [:female, :male]

  belongs_to :user

  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :patronymic, maximum: NAME_LIMIT
  validates_length_of :surname, maximum: NAME_LIMIT
  validates_uniqueness_of :user_id

  def self.entity_parameters
    excluded = %w(id user_id created_at updated_at)
    column_names.reject { |c| excluded.include? c }
  end

  def search_string
    "#{name} #{surname}"
  end
end
