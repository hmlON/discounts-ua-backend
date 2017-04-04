require 'dotenv/load'
require 'sinatra'
require 'sinatra/activerecord'
Dir['./models/*.rb'].each { |file| require file }
require './websites/silpo'

get '/' do
  check_existance_of_active_periods
  shops = Shop.includes(discount_types: { periods: :discounts }).all
  slim :index, locals: { shops: shops }
end

def check_existance_of_active_periods
  Shop.all.each do |shop|
    shop.discount_types.each do |discount_type|
      Silpo.new.public_send(discount_type.name.to_sym) unless discount_type.active_period
    end
  end
end
