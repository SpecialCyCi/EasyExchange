require 'grape'
require "helpers"
module Api
  class Root < Grape::API
    version 'v1', using: :header, vendor: 'testAPI'
    prefix 'api'
    format :json
    helpers APIHelpers

    get :ping do
      "pong"
    end

    get :test do
      authenticated?
      "you are authenticated"
    end
  end
end
