class Image < ActiveRecord::Base

  belongs_to :recipe

  mount_uploader :file, ImageUploader

end
