require './application'

run Rack::URLMap.new(
  '/' => Raddocs::App,
  '/api' => ApiController,
  '/sidekiq' => Sidekiq::Web
)
