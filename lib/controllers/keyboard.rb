class Controllers::Application < Sinatra::Base
  get '/keyboards', auth: :user do
    serialize(200, current_user.keyboards, serializer: Serializers::Keyboard)
  end

  post '/keyboards', auth: :user do
    required!(:name)

    keyboard = Models::Keyboard.create!(user_id: current_user.id, name: params_body[:name])

    serialize(200, keyboard, serializer: Serializers::Keyboard)
  end

  get '/keyboards/:keyboard_id', auth: :user do
    keyboard = current_user.keyboards.find(params[:keyboard_id])

    serialize(200, keyboard, serializer: Serializers::Keyboard)
  end

  patch '/keyboards/:keyboard_id', auth: :user do
    required!(:name)

    keyboard = current_user.keyboards.find(params[:keyboard_id])
    keyboard.update!(name: params_body[:name])

    serialize(200, keyboard, serializer: Serializers::Keyboard)
  end

  post '/keyboards/:keyboard_id/keys', auth: :user do
    required!(:sound_id, :key)

    keyboard = current_user.keyboards.find(params[:keyboard_id])
    sound    = current_user.sounds.find(params_body[:sound_id])

    return serialize(400, { error: 'invalid_key' }) unless keyboard.upsert_sound!(params_body[:key], sound)

    serialize(200, keyboard, serializer: Serializers::Keyboard)
  end
end
