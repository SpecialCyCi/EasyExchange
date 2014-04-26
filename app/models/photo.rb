class Photo
  include Mongoid::Document
  mount_uploader :picture, PhotoUploader
  belongs_to :product
end
