require 'dotenv/load'
require 'sinatra/activerecord'
require 'aws-sdk-s3'
require 'json'
require 'require_all'
require 'active_model_serializers'

require_all 'lib/services/*.rb'
require_all 'lib/models/*.rb'
require_all 'lib/serializers/*.rb'

if ARGV[0] == '-server'
  require 'sinatra/base'
  require_relative 'lib/controllers/helpers.rb'
  require_relative 'lib/controllers/application.rb'
  require_relative 'lib/controllers/keyboard.rb'
  require_relative 'lib/controllers/sound.rb'
  require_relative 'lib/controllers/user.rb'

  Controllers::Application.start!
end
