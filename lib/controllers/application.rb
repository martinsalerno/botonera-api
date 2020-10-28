#TODO ADD AUTHENTICATION AND TOKENS 
module Controllers
  class Application < Sinatra::Base
    include Helpers

    set :show_exceptions, :after_handler

    error ActiveRecord::RecordNotFound do
      'So what happened was...' + env['sinatra.error'].message
    end

    error ActiveRecord::RecordNotUnique do
      'So what happened was...' + env['sinatra.error'].message
    end

    error Helpers::MissingParameterError do
      'So what happened was...' + env['sinatra.error'].message
    end
  end
end
