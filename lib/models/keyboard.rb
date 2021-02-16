module Models
  class Keyboard < ActiveRecord::Base
    belongs_to :user

    DEFAULT_KEYBOARD_NAME = 'My keyboard'.freeze
    VALID_KEYS            = ('a'..'z').freeze

    def upsert_sound!(key, sound)
      return false unless VALID_KEYS.include?(key)

      keys[key] = {
        sound_id: sound.id,
        sound_name: sound.name
      }

      save!
    end

    def self.empty(name = DEFAULT_KEYBOARD_NAME)
      new(
        name: name,
        keys: VALID_KEYS.each_with_object({}) { |key, accum| accum[key] = {} }
      )
    end
  end
end
