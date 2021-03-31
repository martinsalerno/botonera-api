module Controllers
  class Application < Sinatra::Base
    include Helpers

    TOKEN_HEADER      = 'x-botonera-token'.freeze
    ALLOW_HEADERS     = "authorization, content-type, accept, #{TOKEN_HEADER}".freeze

    set :show_exceptions, false

    set(:auth) do |*roles|
      condition do
        halt(401) unless user_logged? && roles.include?(:user)
      end
    end

    before do
      content_type('application/json')
      response.headers['Access-Control-Allow-Origin'] = '*'
    end

    options '*' do
      response.headers['Allow'] = 'GET, PUT, POST, DELETE, OPTIONS'
      response.headers['Access-Control-Allow-Headers'] = ALLOW_HEADERS
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
      { error: env['sinatra.error'].backtrace }.to_json
    end
  end
end
