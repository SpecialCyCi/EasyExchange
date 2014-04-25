class Photo
  include Mongoid::Document
  mount_uploader :picture, PhotoUploader
end
