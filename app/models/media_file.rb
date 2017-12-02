class MediaFile < ApplicationRecord
  belongs_to :media_folder
  belongs_to :user
  belongs_to :agent
end
