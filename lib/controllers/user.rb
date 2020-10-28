class Controllers::Application < Sinatra::Base
  post '/oauth/gmail' do
  end

  post '/oauth/facebook' do
  end

  get '/:user_id' do
    user = Models::User.find(params[:user_id])

    serialize(200, user, serializer: Serializers::User)
  end
end
