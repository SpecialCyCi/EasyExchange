require 'grape'
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
          else
          end
        else
          error!({ "error" => "Username existed" }, 403)
        end
      end

      get :my do
        authenticated?
        current_user.to_my_profile
      end

      get ":id" do
        User.find(params[:id]).to_other_profile
      end

      post "update" do
        authenticated?
        new_params = ActionController::Parameters.new(params).require(:user).permit(:avatar, :nickname)
        current_user.update_attributes(new_params)
        { message: "success" }
      end

    end



  end
end
