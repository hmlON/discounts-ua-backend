require 'dotenv/load'
require 'sinatra'
require 'sinatra/activerecord'
require './models/shop'
require './models/discount'
require './websites/silpo'

get '/' do
  discounts = Silpo.new.discounts
  slim :index, locals: { discounts: discounts }
end
