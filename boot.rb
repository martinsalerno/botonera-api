require 'dotenv/load'
require 'sinatra/activerecord'
require 'aws-sdk-s3'
require 'json'
require 'require_all'
require 'active_model_serializers'
require 'http'

require_all 'lib/services/*.rb'
require_all 'lib/services/oauth/*.rb'
require_all 'lib/models/*.rb'
require_all 'lib/serializers/*.rb'

require 'sinatra/base'
require_relative 'lib/controllers/helpers'
require_relative 'lib/controllers/application'
require_relative 'lib/controllers/keyboard'
require_relative 'lib/controllers/sound'
require_relative 'lib/controllers/user'

class Configuration
  class << self
    def method_missing(name)
      ENV[name.to_s.upcase]
    end

    def respond_to_missing?(_, _)
      true
    end
  end
end

Controllers::Application.start! if ARGV[0] == '-server'
