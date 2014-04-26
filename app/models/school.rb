class School
  include Mongoid::Document
  include Sunspot::Mongoid
  has_many :users
  has_many :products
  field :name, :type => String

end
