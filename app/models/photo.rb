class Photo
  include Mongoid::Document
  mount_uploader :picture, PhotoUploader
  embedded_in :product
end
