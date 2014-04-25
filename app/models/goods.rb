class Goods
  include Mongoid::Document
  include Mongoid::Timestamps
  include Sunspot::Mongo

  field :name, type: String
  field :description, type: String
  field :durbility, type: Integer
  field :price, type: Float
  field :longitude, type: Float # 经度
  field :latitude, type: Float  # 纬度
  validates_presence_of :name
  validates_presence_of :durbility
  validates_presence_of :price
  has_many :goods_options
  has_many :photos
  belongs_to :user
  accepts_nested_attributes_for :goods_options, :photos, allow_destroy: true
  default_scope -> {order_by(:created_at => :desc)}

  searchable do
    text :name
    text :description
    time :created_at
    time :updated_at
    float :longitude
    float :latitude
    float :price
    integer :durbility
  end
end
