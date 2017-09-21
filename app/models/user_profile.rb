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

  def age
    now    = Time.now
    bd     = birthday || now
    result = now.year - bd.year
    result = result - 1 if (bd.month > now.month || (bd.month >= now.month && bd.day > now.day))
    result
  end
end
