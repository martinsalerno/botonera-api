require 'dotenv/load'
require 'sinatra/activerecord'
require 'aws-sdk-s3'
require 'json'
require 'require_all'
require 'active_model_serializers'

require_all 'lib/services/*.rb'
require_all 'lib/models/*.rb'
require_all 'lib/serializers/*.rb'

require 'sinatra/base'
require_relative 'lib/controllers/helpers'
require_relative 'lib/controllers/application'
require_relative 'lib/controllers/keyboard'
require_relative 'lib/controllers/sound'
require_relative 'lib/controllers/user'

Controllers::Application.start! if ARGV[0] == '-server'
