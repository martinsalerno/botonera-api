# TODO: ADD AUTHENTICATION AND TOKENS
module Controllers
  class Application < Sinatra::Base
    include Helpers

    set :show_exceptions, false

    before do
      content_type('application/json')
      response.headers['Access-Control-Allow-Origin'] = '*'
    end

    options '*' do
      response.headers['Allow'] = 'GET, PUT, POST, DELETE, OPTIONS'
      response.headers['Access-Control-Allow-Headers'] = 'Authorization, Content-Type, Accept, X-User-Email, X-Auth-Token'
      response.headers['Access-Control-Allow-Origin']  = '*'

      200
    end

    error ActiveRecord::RecordNotFound do
      { error: env['sinatra.error'].message }.to_json
    end

    error ActiveRecord::RecordNotUnique do
      { error: env['sinatra.error'].message }.to_json
    end

    error Helpers::MissingParameterError do
      { error: env['sinatra.error'].message }.to_json
    end

    error do
      puts env['sinatra.error'].backtrace
      { error: env['sinatra.error'].backtrace }.to_json
    end
  end
end
