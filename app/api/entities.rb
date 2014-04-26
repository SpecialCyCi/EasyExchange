require 'grape'
module Entities

  class ToOtherUser < Grape::Entity
    expose :id, :nickname, :created_at
    expose :avatar do |model, opts|
      { thumb: model.avatar.thumb.url, medium: model.avatar.medium.url, origin: model.avatar.origin.url }
    end
  end

  class ToMyUser < Grape::Entity
    expose :id, :nickname, :created_at
    expose :avatar do |model, opts|
      { thumb: model.avatar.thumb.url, medium: model.avatar.medium.url, origin: model.avatar.origin.url }
    end
  end

  class Product < Grape::Entity
    expose :id, :name, :description, :durbility, :price, :product_options, :created_at, :updated_at 
    expose :user do |model, opts|
      Entities::ToOtherUser.represent model.user
    end
    expose :photos do |model, opts|
      model.photos.map{ |e| { thumb: e.picture.thumb.url, medium: e.picture.medium.url, origin: e.picture.origin.url }}
    end
  end

end
