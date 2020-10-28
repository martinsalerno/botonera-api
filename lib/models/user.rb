module Models
  class User < ActiveRecord::Base
    enum oauth_provider: %i[gmail facebook]

    has_many :sounds
    has_many :keyboards
  end
end
