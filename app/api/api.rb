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
        new_params = ActionController::Parameters.new(params).require(:user).permit(:avatar, :nickname, :school_id)
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
        @products = Product.where(school_id: params[:school_id]).paginate(:page => params[:page], :per_page => params[:per_page]||10)
        present @products, :with => Entities::Product
      end

      get ":id", requirements: { id: /[0-9]*/ } do
        @products = Product.find(params[:id])
        present @products, :with => Entities::Product
      end

      get "my" do
        authenticated?
        @products = current_user.paginate(:page => params[:page], :per_page => params[:per_page]||10)
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
        new_params = ActionController::Parameters.new(params).require(:product).permit(:name, :description, :photos_attributes, :durability, :price, :product_options_attributes, :origin_price, :publishing_company, :writer, :exchangeable, :want_exchange, :tags)
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
      get "search" do
        query_params = {}
        sort_params = []
        product_class = Product
        if !params[:distance].blank? && !params[:latitude].blank? && !params[:longitude].blank?
          location = [ params[:latitude].to_f, params[:longitude].to_f ]
          query_params = query_params.merge({
            :loc => {"$near" => location, '$maxDistance' => params[:distance].to_i.fdiv(111.12) }
          })
        end
        if !params[:keyword].blank?
          query_params = query_params.merge(name: /#{params[:keyword]}/)
        end
        if !params[:school_id].blank?
          query_params = query_params.merge(school_id: /#{params[:school_id]}/)
        end
        if !params[:order_by].blank?
          params[:order_direction] ||= :desc
          sort_params << [ params[:order_by], params[:order_direction] ]
          product_class = Product.unscoped
        end
        
        @products = product_class.where(query_params).order_by(sort_params)
                    .paginate(:page => params[:page], :per_page => params[:per_page]||10)
        present @products, :with => Entities::Product
      end

    end

    resource :school do

      get 'search' do
        @schools = School.where(name: /#{params[:keyword]}/)
                      .paginate(:page => params[:page], :per_page => params[:per_page]||30)
        present @schools, :with => Entities::School
      end

    end
  end

end
