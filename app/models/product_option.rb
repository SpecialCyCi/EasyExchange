class ProductOption
  include Mongoid::Document
  include Mongoid::Timestamps
  field :key, type: String
  field :value, type: String
  embedded_in :product

end
