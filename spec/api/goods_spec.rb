require "spec_helper"

describe Api::Root do
  include SolrSpecHelper

  before(:all) do
    solr_setup
  end

  after(:all) do
    Goods.remove_all_from_index!
  end

  let(:user) { FactoryGirl.create :user }
  let(:good) { FactoryGirl.create :good }

  def login
    post "/api/user/login", { username: user.username, password: user.password }
    response.status.should == 201
    json = JSON.parse(response.body)
    return json["auth_token"]
  end

  describe "list" do

    before do
      FactoryGirl.create_list :good, 100
    end

    it "should return goods list" do
      get "/api/goods", { page: 1 }
      json = JSON.parse(response.body)
      json.length.should_not eq 0
    end

  end

  # 获取单件商品信息
  describe "get" do

    it "should get right" do
      good
      get "/api/goods/#{good.id}"
      puts response.body
      json = JSON.parse(response.body)
      json["name"].should eq good.name
    end

  end

  describe "create goods" do

    it "should create success" do
      attributes = FactoryGirl.attributes_for(:good)
      # attributes = attributes.merge(goods_options_attributes: Array(1..5).sample.times.map{ FactoryGirl.attributes_for :goods_option  })
      expect{
        post "/api/goods/create", { goods: attributes, auth_token: login }
      }.to change(Goods, :count).by(1)
      Goods.last.user.should eq user
    end

  end

  describe "update goods" do

    it "should update success" do
      token = login
      post "/api/goods/create", { goods: FactoryGirl.attributes_for(:good), auth_token: token }
      _good = Goods.first
      post "/api/goods/#{_good.id}/update", { goods: { name: "abc" }, auth_token: token }
      _good.reload.name.should eq "abc"
    end

  end

  describe "destroy goods" do

    it "should detroy" do
      token = login
      post "/api/goods/create", { goods: FactoryGirl.attributes_for(:good), auth_token: token }
      _good = Goods.first
      expect{
        post "/api/goods/#{_good.id}/destroy", { auth_token: token }
      }.to change(Goods, :count).by(-1)
    end

  end

  describe "search goods" do

    before do
      FactoryGirl.create_list :good, 100
    end

    it "should show want goods" do
      get "/api/goods/search/h"
      json = JSON.parse(response.body)
      json.length.should_not eq 0
    end

  end
end
