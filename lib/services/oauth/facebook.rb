module OAuth
  class Facebook < Base
    TOKEN_ENDPOINT         = 'https://graph.facebook.com/v8.0/oauth/access_token'.freeze
    PROFILE_ENDPOINT       = 'https://graph.facebook.com/me'.freeze
    AUTHORIZATION_ENDPOINT = 'https://www.facebook.com/v8.0/dialog/oauth'.freeze

    class << self
      def authorization_url
        params = {
          client_id: Configuration.FACEBOOK_CLIENT_ID,
          redirect_uri: Configuration.FACEBOOK_REDIRECT_URI,
          response_type: 'code',
          scope: 'email user_photos'
        }

        "#{AUTHORIZATION_ENDPOINT}?#{params.to_query}"
      end

      private

      def fetch_access_token(code)
        HTTP.post(TOKEN_ENDPOINT,
                  json: {
                    code: code,
                    client_id: Configuration.FACEBOOK_CLIENT_ID,
                    client_secret: Configuration.FACEBOOK_CLIENT_SECRET,
                    redirect_uri: Configuration.FACEBOOK_REDIRECT_URI
                  })
      end

      def fetch_profile(access_token)
        HTTP.get(PROFILE_ENDPOINT,
                 params: {
                   access_token: access_token
                 })
      end

      def standarize_response(response)
        {
          email: response['email'],
          oauth_user_id: response['id'],
          oauth_user_name: response['name'],
          oauth_user_picture: response['picture'],
          oauth_refresh_token: response['refresh_token'],
          oauth_provider: Models::User.oauth_providers[:facebook]
        }
      end
    end
  end
end
