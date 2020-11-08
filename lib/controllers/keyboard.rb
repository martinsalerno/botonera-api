class Controllers::Application < Sinatra::Base
  get '/:user_id/keyboards' do
    user = Models::User.includes(:keyboards).find(params[:user_id])

    serialize(200, user.keyboards, serializer: Serializers::Keyboard)
  end

  post '/:user_id/keyboards' do
    required!(:name)

    user     = Models::User.find(params[:user_id])
    keyboard = Models::Keyboard.create!(user_id: user.id, name: params_body[:name])

    serialize(200, keyboard, serializer: Serializers::Keyboard)
  end

  get '/:user_id/keyboards/:keyboard_id' do
    keyboard = Models::User.find(params[:user_id]).keyboards.find(params[:keyboard_id])

    serialize(200, keyboard, serializer: Serializers::Keyboard)
  end

  patch '/:user_id/keyboards/:keyboard_id' do
    required!(:name)

    keyboard = Models::User.find(params[:user_id]).keyboards.find(params[:keyboard_id])
    keyboard.update!(name: params_body[:name])

    serialize(200, keyboard, serializer: Serializers::Keyboard)
  end

  post '/:user_id/keyboards/:keyboard_id/keys' do
    required!(:sound_id, :key)

    user     = Models::User.find(params[:user_id])
    keyboard = user.keyboards.find(params[:keyboard_id])
    sound    = user.sounds.find(params_body[:sound_id])

    return serialize(400, { error: 'invalid_key' }) unless keyboard.upsert_sound!(params_body[:key], sound)

    serialize(200, keyboard, serializer: Serializers::Keyboard)
  end
end
