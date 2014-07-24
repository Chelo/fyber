require 'sinatra'
require 'httparty'
require_relative "helpers/utils"
require_relative "conf/config"
include Utils

get '/' do
  haml :index
end

post '/' do
  #get inputs and set time
  inputs = {
    pub0: params[:pub0],
    page: params[:page],
    uid: params[:uid],
    timestamp: Time.now.to_i
  }

  data = settings.data

  #merge with data
  data.merge! inputs

  #get url from data
  url = create_url data

  #make call
  response = HTTParty.get(url)
  body = JSON.parse response.body

  #handle response
  if response.code == 200 
    @offers = body["offers"]
    haml :offers
  else
    @message = body["message"]
    @code = body["code"]
    haml :error
  end
end
