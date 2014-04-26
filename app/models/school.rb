class School
  include Mongoid::Document
  include Sunspot::Mongoid
  field :name, :type => String
  searchable do
    text :name
  end

end
