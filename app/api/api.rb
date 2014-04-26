# encoding: utf-8
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
        if !params[:user][:avatar].blank?
          current_user.avatar = params[:user][:avatar]
          current_user.save
        end
        current_user.update_attributes(new_params)
        { message: "success" }
      end

    end

    resource :product do

      get do
        @products = Product.paginate(:page => params[:page], :per_page => params[:per_page]||10)
        present @products, :with => Entities::Product
      end

      get ":id" do
        @products = Product.find(params[:id])
        present @products, :with => Entities::Product
      end

      post :create do
        authenticated?
        Product.create(params[:product].merge(user: current_user))
        { message: "success" }
      end

      post ":id/update" do
        authenticated?
        @product = Product.find(params[:id])
        error!({ "error" => "Not your product!" }, 405) if @product.user != current_user
        new_params = ActionController::Parameters.new(params).require(:product).permit(:name, :description, :photos_attributes, :durbility, :price, :product_options_attributes )
        if @product.update_attributes(new_params)
          { message: "success" }
        else
          error!({ "error" => @product.errors.full_messages }, 403)
        end
      end

      post ":id/destroy" do
        authenticated?
        @product = Product.find(params[:id])
        error!({ "error" => "Not your product!" }, 405) if @product.user != current_user
        @product.destroy
        { message: "success" }
      end

      # 搜索
      get "search/:keyword" do
        @products = Product.solr_search do
          fulltext params[:keyword]
          paginate :page => params[:page], :per_page => 10
        end.results
        present @products, :with => Entities::Product
      end

    end

  end
end
