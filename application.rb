require 'dotenv/load'
require 'sinatra'
require './websites/silpo'

get '/' do
  discounts = Silpo.new.discounts
  # p discounts
  slim :index, locals: { discounts: discounts }
end
