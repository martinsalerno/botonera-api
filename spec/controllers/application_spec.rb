require 'sinatra/base'
require_relative '../../lib/controllers/helpers'
require_relative '../../lib/controllers/application'
require_relative '../../lib/controllers/keyboard'
require_relative '../../lib/controllers/sound'
require_relative '../../lib/controllers/user'

module Controllers
  module Test
    def app
      Controllers::Application
    end
  end
end

describe Controllers::Application do
  include Controllers::Test
end
