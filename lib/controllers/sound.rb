module Controllers
  class Application < Sinatra::Base
    get '/sounds', auth: :user do
      serialize(200, current_user.sounds, serializer: Serializers::Sound)
    end

    post '/sounds', auth: :user do
      required!(:name)

      sound = current_user.sounds.create!(
        name: params_body[:name],
        path: "#{current_user.id}/sounds/#{params_body[:name]}"
      )

      serialize(200, sound, serializer: Serializers::Sound)
    end

    post '/sounds/new_url', auth: :user do
      required!(:name)

      path = "#{current_user.id}/sounds/#{params_body[:name]}"

      serialize(200, { url: S3.presign_put_url(path) })
    end

    patch '/sounds/:sound_id', auth: :user do
      required!(:name)

      sound = current_user.sounds.find(params[:sound_id])
      sound.update!(name: params_body[:name])

      serialize(200, sound.reload, serializer: Serializers::Sound)
    end
  end
end
