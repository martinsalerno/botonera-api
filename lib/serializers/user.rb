module Serializers
  class User < ActiveModel::Serializer
    attributes :id, :email, :oauth_provider, :keyboards

    def keyboards
      object.keyboards.map do |keyboard|
        {
          id: keyboard.id,
          name: keyboard.name
        }
      end
    end
  end
end
