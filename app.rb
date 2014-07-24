require 'sinatra'

get '/' do
  haml :index
end

post '/' do
  @pub0 = params[:pub0]
  @page = params[:page]
  @uid = params[:uid]
  haml :offers
end
