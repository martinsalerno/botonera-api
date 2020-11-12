class Controllers::Application < Sinatra::Base
  get '/oauth' do
    serialize(200, {
                google: OAuth::Google.authorization_url,
                facebook: OAuth::Facebook.authorization_url
              })
  end

  get '/oauth/google' do
    code = params[:code]

    return serialize(400, error: 'unknown') if code.nil?

    user_info = OAuth::Google.fetch_user(code)
    puts user_info

    serialize(400, {}) if user_info.include?(:error)

    serialize(200, {})
  end

  get '/oauth/facebook' do
    code = params[:code]

    return serialize(400, error: 'unknown') if code.nil?

    user_info = OAuth::Facebook.fetch_user(code)
    puts user_info

    serialize(400, {}) if user_info.include?(:error)

    serialize(200, {})
  end

  get 'users/:user_id' do
    user = Models::User.find(params[:user_id])

    serialize(200, user, serializer: Serializers::User)
  end
end
