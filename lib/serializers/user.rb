module Serializers
  class User < ActiveModel::Serializer
    attributes :id, :email, :oauth_provider, :oauth_user_picture, :default_keyboard, :keyboards

    def default_keyboard
      return nil if object.keyboards.first.nil?

      Serializers::Keyboard.new(object.keyboards.first)
    end

    def keyboards
      object.keyboards.map do |keyboard|
        {
          id:   keyboard.id,
          name: keyboard.name
        }
      end
    end
  end
end
