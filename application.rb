require 'sinatra'
require './websites/silpo'

get '/' do
  discounts = Silpo.new.discounts
  slim :index, locals: { discounts: discounts }
end
