module Models
  class Keyboard < ActiveRecord::Base
    belongs_to :user

    VALID_KEYS = ('a'..'z').freeze

    def upsert_sound!(key, sound)
      return false unless VALID_KEYS.include?(key)

      keys[key] = {
        sound_id: sound.id,
        sound_name: sound.name
      }

      save!
    end
  end
end
