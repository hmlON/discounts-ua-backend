require 'dotenv/load'
require 'sinatra'
require 'sinatra/activerecord'
Dir['./models/*.rb'].each { |file| require file }
require './websites/silpo'

get '/' do
  discounts = Silpo.new.discounts
  discounts = Discount.all
  slim :index, locals: { discounts: discounts }
end
