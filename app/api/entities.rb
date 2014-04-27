require 'grape'
module Entities

  class ToOtherUser < Grape::Entity
    expose :id, :nickname, :created_at
    expose :school do |model, opts|
      Entities::School.represent model.school
    end
    expose :avatar do |model, opts|
      { thumb: model.avatar.thumb.url, medium: model.avatar.medium.url, origin: model.avatar.origin.url }
    end
  end

  class ToMyUser < Grape::Entity
    expose :id, :nickname, :created_at
    expose :school do |model, opts|
      Entities::School.represent model.school
    end
    expose :avatar do |model, opts|
      { thumb: model.avatar.thumb.url, medium: model.avatar.medium.url, origin: model.avatar.origin.url }
    end
  end

  class Product < Grape::Entity
    expose :id, :name, :description, :durability, :price, :product_options, :created_at, :updated_at, :latitude, :longitude, :contacter, :contact, :origin_price, :publishing_company, :writer
    expose :school do |model, opts|
      Entities::School.represent model.school
    end
    expose :user do |model, opts|
      Entities::ToOtherUser.represent model.user
    end
    expose :photos do |model, opts|
      model.photos.map{ |e| { thumb: e.picture.thumb.url, medium: e.picture.medium.url, origin: e.picture.origin.url }}
    end
  end

  class School < Grape::Entity
    expose :id, :name
  end
end
