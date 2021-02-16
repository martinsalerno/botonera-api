module Models
  class User < ActiveRecord::Base
    enum oauth_provider: %i[google facebook]

    has_many :sounds, dependent: :delete_all
    has_many :keyboards, dependent: :delete_all

    def create_default_keyboard!
      keyboards << Models::Keyboard.empty
    end
  end
end
