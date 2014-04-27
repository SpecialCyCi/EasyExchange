class Product
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :description, type: String
  field :durability, type: Integer
  field :price, type: Float
  field :latitude, type: Float  # 纬度
  field :longitude, type: Float # 经度
  field :contacter, type: String
  field :contact, type: String
  field :loc, :type => Array
  validates_presence_of :name
  validates_presence_of :durability
  validates_presence_of :price
  embeds_many :product_options, cascade_callbacks: true
  embeds_many :photos, cascade_callbacks: true
  belongs_to :user
  belongs_to :school

  accepts_nested_attributes_for :product_options, allow_destroy: true
  accepts_nested_attributes_for :photos, allow_destroy: true


  default_scope -> {order_by(:created_at => :desc)}
  index({ loc: Mongo::GEO2D}, { background: true })
  before_save :set_loc

  def set_loc
    self.loc = [ self.latitude, self.longitude ]
  end

end
