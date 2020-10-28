module Models
  class Keyboard < ActiveRecord::Base
    belongs_to :user

    VALID_KEYS = 'a'..'z'

    def upsert_sound!(key, sound)
      return false unless VALID_KEYS.include?(key)

      keys[key] = {
        key: key,
      	sound: {
      	  id:   sound.id,
      	  path: sound.path
      	}
      }

      save!
    end
  end
end
