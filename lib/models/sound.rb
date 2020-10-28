module Models
  class Sound < ActiveRecord::Base
    belongs_to :user
  end
end