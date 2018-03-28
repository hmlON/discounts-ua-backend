require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require 'rspec/core/rake_task'
require 'bundler'
Bundler.require(:default)
Dir['./app/models/*.rb'].each { |file| require file }
Dir['./config/*.rb'].each { |file| require file }
Dir['./lib/*.rb'].each { |file| require file }
Dir['./app/services/*.rb'].each { |file| require file }
# Dir['./app/workers/*.rb'].each { |file| require file }

desc 'Parse shops'
task :parse do
  Shop.find_each do |shop|
    ShopParser.new(shop).call
  end
end

desc 'Generate API request documentation from API specs'
RSpec::Core::RakeTask.new('docs:generate') do |t|
  t.pattern = 'spec/api_spec.rb'
  t.rspec_opts = ['--format RspecApiDocumentation::ApiFormatter']
end
