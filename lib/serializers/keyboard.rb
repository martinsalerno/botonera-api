module Serializers
  class Keyboard < ActiveModel::Serializer
    attributes :id, :name, :keys
  end
end
