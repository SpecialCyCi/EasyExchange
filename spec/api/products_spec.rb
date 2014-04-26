require "spec_helper"

describe Api::Root do

  let(:user) { FactoryGirl.create :user }
  let(:product) { FactoryGirl.create :product }

  def login
    post "/api/user/login", { username: user.username, password: user.password }
    response.status.should == 201
    json = JSON.parse(response.body)
    return json["auth_token"]
  end

  describe "list" do

    before do
      FactoryGirl.create_list :product, 100
    end

    it "should return products list" do
      get "/api/product", { page: 1 }
      json = JSON.parse(response.body)
      json.length.should_not eq 0
    end

  end

  # 获取单件商品信息
  describe "get" do

    it "should get right" do
      product
      get "/api/product/#{product.id}"
      puts response.body
      json = JSON.parse(response.body)
      json["name"].should eq product.name
    end

  end

  describe "create product" do

    it "should create success" do
      attributes = FactoryGirl.attributes_for(:product)
      # attributes = attributes.merge(goods_options_attributes: Array(1..5).sample.times.map{ FactoryGirl.attributes_for :goods_option  })
      expect{
        post "/api/product/create", { product: attributes, auth_token: login }
      }.to change(Product, :count).by(1)
      Product.last.user.should eq user
    end

  end

  describe "update product" do

    it "should update success" do
      token = login
      post "/api/product/create", { product: FactoryGirl.attributes_for(:product), auth_token: token }
      _product = Product.first
      post "/api/product/#{_product.id}/update", { product: { name: "abc" }, auth_token: token }
      _product.reload.name.should eq "abc"
    end

  end

  describe "destroy product" do

    it "should detroy" do
      token = login
      post "/api/product/create", { product: FactoryGirl.attributes_for(:product), auth_token: token }
      _product = Product.first
      expect{
        post "/api/product/#{_product.id}/destroy", { auth_token: token }
      }.to change(Product, :count).by(-1)
    end

  end

end
