class Goods
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String
  field :durbility, type: Integer
  field :price, type: Float
  validates_presence_of :name
  validates_presence_of :durbility
  validates_presence_of :price
  has_many :goods_options
  has_many :photos
  belongs_to :user
  accepts_nested_attributes_for :goods_options, :photos, allow_destroy: true
  default_scope -> {order_by(:created_at => :desc)}

end
