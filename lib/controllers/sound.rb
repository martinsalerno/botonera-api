class Controllers::Application < Sinatra::Base
  get '/:user_id/sounds' do
    user = Models::User.includes(:sounds).find(params[:user_id])

    serialize(200, user.sounds, serializer: Serializers::Sound)
  end

  post '/:user_id/sounds' do
    required!(:name)

    user  = Models::User.find(params[:user_id])

    # TODO: validate it exists on S3?
    # TOOD: validate extension?
    sound = user.sounds.create!(name: params_body[:name], path: "#{user.id}/sounds/#{params_body[:name]}")

    serialize(200, sound, serializer: Serializers::Sound)
  end

  post '/:user_id/sounds/new_url' do
    required!(:name)

    user = Models::User.find(params[:user_id])
    path = "#{user.id}/sounds/#{params_body[:name]}"

    serialize(200, { url: S3.presign_put_url(path) })
  end

  patch '/:user_id/sounds/:sound_id' do
    required!(:name)

    user  = Models::User.find(params[:user_id])
    sound = user.sounds.find(params[:sound_id]).update!(name: params[:name])

    serialize(200, sound, serializer: Serializers::Sound)
  end
end