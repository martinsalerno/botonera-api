class Controllers::Application < Sinatra::Base
  get '/:user_id/sounds' do
    user = Models::User.includes(:sounds).find(params[:user_id])

    serialize(200, user.sounds, serializer: Serializers::Sound)
  end

  post '/:user_id/sound_url' do
    required!(:name)

    user = Models::User.find(params[:user_id])
    path = "#{user.id}/sounds/#{params[:name]}"

    serialize(200, { url: S3.presigned_url(path) })
  end

  post '/:user_id/sounds' do
    required!(:name, :path)

    user  = Models::User.find(params[:user_id])
    sound = Models::Sound.create!(user_id: user.id, name: params[:name], path: params[:path])

    serialize(200, sound, serializer: Serializers::Sound)
  end
end
