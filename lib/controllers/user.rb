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

    user = OAuth::Google.fetch_user(code)

    serialize(400, {}) if user.nil?
    add_cookie_and_redirect!(user)
  end

  get '/oauth/facebook' do
    code = params[:code]

    return serialize(400, error: 'unknown') if code.nil?

    user = OAuth::Facebook.fetch_user(code)

    serialize(400, {}) if user.nil?
    add_cookie_and_redirect!(user)
  end

  get '/me', auth: :user do
    serialize(200, current_user, serializer: Serializers::User)
  end

  post '/logout', auth: :user do
    Session::Cache.remove(token)

    serialize(200, {})
  end

  private

  def add_cookie_and_redirect!(user)
    response.set_cookie('botonera-api',
                        value: Session::Cache.tokenize(user),
                        httponly: false,
                        path: '/')

    redirect(Configuration.FRONT_END_URL)
  end
end
