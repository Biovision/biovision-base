class ForeignSite < ApplicationRecord
  include RequiredUniqueName
  include RequiredUniqueSlug

  has_many :foreign_users, dependent: :delete_all

  def self.page_for_administration
    ordered_by_name
  end
end
