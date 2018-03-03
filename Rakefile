require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require 'bundler'
Bundler.require(:default)
Dir['./app/models/*.rb'].each { |file| require file }
Dir['./config/*.rb'].each { |file| require file }
Dir['./lib/*.rb'].each { |file| require file }
Dir['./app/services/*.rb'].each { |file| require file }
Dir['./app/workers/*.rb'].each { |file| require file }

desc "Parse shops"
task :parse do
  Shop.find_each do |shop|
    ShopParser.new(shop).call
  end
end
