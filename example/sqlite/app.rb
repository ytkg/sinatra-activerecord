require 'sinatra'
require 'sinatra/activerecord'

class User < ActiveRecord::Base
end

class App < Sinatra::Base
  before do
    content_type :json
  end

  get '/' do
    p 'Hello!'
  end

  get '/users/?' do
    @users = User.all
    @users.to_json
  end

  get '/users/:id/?' do
    @user = User.find_by_id(params[:id])
    @user.to_json
  end
end

