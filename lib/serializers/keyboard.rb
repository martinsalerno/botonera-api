module Serializers
  class Keyboard < ActiveModel::Serializer
    attributes :id, :name, :keys

    def keys
      object.keys.each_with_object({}) do |(key, value), accum|
        next accum[key] = {} if value.empty?

        sound = Models::Sound.find(value['sound_id'])

        accum[key] = {
          sound_id:   sound.id,
          sound_name: sound.name,
          sound_url:  sound.download_link
        }
      end
    end
  end
end
