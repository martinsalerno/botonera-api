module Serializers
  class Keyboard < ActiveModel::Serializer
    attributes :id, :name, :keys

    def keys
      object.keys.each_with_object({}) do |(key, value), accum|
        accum[key] = {
          sound_id: value['sound_id'],
          sound_name: value['sound_name']
        }
      end
    end
  end
end
