class Product
  include Mongoid::Document
  include Mongoid::Timestamps
  include Sunspot::Mongoid

  field :name, type: String
  field :description, type: String
  field :durbility, type: Integer
  field :price, type: Float
  field :latitude, type: Float  # 纬度
  field :longitude, type: Float # 经度
  field :loc, :type => Array
  validates_presence_of :name
  validates_presence_of :durbility
  validates_presence_of :price
  has_many :product_options
  has_many :photos
  belongs_to :user
  belongs_to :school
  accepts_nested_attributes_for :product_options, :photos, allow_destroy: true
  default_scope -> {order_by(:created_at => :desc)}
  index({ loc: Mongo::GEO2D}, { background: true })
  before_save :set_loc

  def set_loc
    self.loc = [ self.latitude, self.longitude ]
  end

  searchable do
    text :name, :description
    time :created_at
    time :updated_at
    float :longitude
    float :latitude
    float :price
    integer :durbility
  end
end
