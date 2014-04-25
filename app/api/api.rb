require 'grape'
require "entities"
require "helpers"
module Api
  class Root < Grape::API

    version 'v1', using: :header, vendor: 'testAPI'
    prefix 'api'
    format :json
    helpers APIHelpers

    resource :user do

      post :login do
        user = User.login(params[:username], params[:password])
        if user
          { auth_token: user.authentication_token }
        else
          error!({ "error" => "Unauthorized" }, 401)
        end
      end

      post :sign_in do
        error!({}, 500) if params[:password].blank?
        if !User.where(username: params[:username]).exists?
          if user = User.sign_in(params[:username], params[:password])
            { auth_token: user.authentication_token }
          end
        else
          error!({ "error" => "Username existed" }, 403)
        end
      end

      get :my do
        authenticated?
        present current_user, :with => Entities::ToMyUser
      end

      get ":id" do
        present User.find(params[:id]), :with => Entities::ToOtherUser
      end

      post "update" do
        authenticated?
        new_params = ActionController::Parameters.new(params).require(:user).permit(:avatar, :nickname)
        current_user.update_attributes(new_params)
        { message: "success" }
      end

    end

    resource :goods do

      get do
        @goods = Goods.paginate(:page => params[:page], :per_page => params[:per_page]||10)
        present @goods, :with => Entities::Goods
      end

      get ":id" do
        @goods = Goods.find(params[:id])
        present @goods, :with => Entities::Goods
      end

      post :create do
        authenticated?
        Goods.create(params[:goods].merge(user: current_user))
        { message: "success" }
      end

      post ":id/update" do
        authenticated?
        @goods = Goods.find(params[:id])
        error!({ "error" => "Not your goods!" }, 405) if @goods.user != current_user
        new_params = ActionController::Parameters.new(params).require(:goods).permit(:name, :description, :photos_attributes, :durbility, :price, :goods_options_attributes )
        if @goods.update_attributes(new_params)
          { message: "success" }
        else
          error!({ "error" => @goods.errors.full_messages }, 403)
        end
      end

      post ":id/destroy" do
        authenticated?
        @goods = Goods.find(params[:id])
        error!({ "error" => "Not your goods!" }, 405) if @goods.user != current_user
        @goods.destroy
        { message: "success" }
      end

    end

  end
end
