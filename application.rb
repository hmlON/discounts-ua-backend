require 'bundler'
Bundler.require(:default)

Bundler.require(:development) if development?
require 'sinatra/reloader' if development?

require 'sidekiq/web'

Dir['./app/models/*.rb'].each { |file| require file }
Dir['./app/serializers/*.rb'].each { |file| require file }
set :serializers_path, './models/serializers'

Dir['./config/*.rb'].each { |file| require file }
Dir['./lib/*.rb'].each { |file| require file }

Dir['./app/services/*.rb'].each { |file| require file }
Dir['./app/workers/*.rb'].each { |file| require file }
Dir['./app/controllers/*.rb'].each { |file| require file }
