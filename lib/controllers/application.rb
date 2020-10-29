# TODO: ADD AUTHENTICATION AND TOKENS
module Controllers
  class Application < Sinatra::Base
    include Helpers

    set :show_exceptions, false

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
