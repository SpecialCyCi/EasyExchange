require "spec_helper"

describe Api::Root do

  let(:user) { FactoryGirl.create :user }

  def login
    post "/api/user/login", { username: user.username, password: user.password }
    response.status.should == 201
    json = JSON.parse(response.body)
    return json["auth_token"]
  end

  # 登陆
  describe "login" do

    it "should be ok" do
      post "/api/user/login", { username: user.username, password: user.password }
      response.status.should == 201
      json = JSON.parse(response.body)
      json["auth_token"].should_not be_nil
    end

    it "should be not ok" do
      post "/api/user/login", { username: user.username, password: "1" + user.password }
      response.status.should == 401
    end

  end

  # 注册
  describe "sign_in" do

    it "should be ok" do
      expect{
        post "/api/user/sign_in", { username: "except", password: "except" }
      }.to change(User, :count).by(1)
    end

    it "should be not ok" do
      post "/api/user/sign_in", { username: "except", password: "except" }
      expect{
        post "/api/user/sign_in", { username: "except", password: "except" }
      }.to change(User, :count).by(0)
      response.status.should == 403
    end

    it "password can not be nil" do
      post "/api/user/sign_in", { username: "except" }
      response.status.should == 500
    end

  end

  # 获取自己的个人信息
  describe "my" do

    it "should be ok" do
      get "/api/user/my", { auth_token: login }
      response.status.should == 200
      json = JSON.parse(response.body)
      json.has_key?("nickname").should be_true
    end

    it "should be not ok" do
      get "/api/user/my", { auth_token: "1" }
      response.status.should == 401
    end

  end

  # 获取其他人信息
  describe "other" do

    it "should be ok" do
      user
      get "/api/user/#{user.id}"
      json = JSON.parse(response.body)
      json.has_key?("nickname").should be_true
    end

  end

  # 更新个人文件
  describe "update" do

    it "should update successfully" do
      post "/api/user/update", { user: { nickname: "abc" }, auth_token: login }
      user.reload.nickname.should eq "abc"
      json = JSON.parse(response.body)
      json["message"].should_not be_nil
    end

  end

end
