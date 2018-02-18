require './application'
# run Sinatra::Application
run Rack::URLMap.new(
  '/' => Sinatra::Application,
  '/sidekiq' => Sidekiq::Web
)
