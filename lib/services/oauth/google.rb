module OAuth
  class Google < Base
    TOKEN_ENDPOINT         = 'https://oauth2.googleapis.com/token'.freeze
    PROFILE_ENDPOINT       = 'https://www.googleapis.com/oauth2/v1/userinfo'.freeze
    AUTHORIZATION_ENDPOINT = 'https://accounts.google.com/o/oauth2/v2/auth'.freeze

    class << self
      def authorization_url
        params = {
          client_id: Configuration.GOOGLE_CLIENT_ID,
          redirect_uri: Configuration.GOOGLE_REDIRECT_URI,
          response_type: 'code',
          access_type: 'offline',
          scope: 'https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email',
          include_granted_scopes: true
        }

        "#{AUTHORIZATION_ENDPOINT}?#{params.to_query}"
      end

      private

      def fetch_access_token(code)
        HTTP.post(TOKEN_ENDPOINT,
                  json: {
                    code: code,
                    client_id: Configuration.GOOGLE_CLIENT_ID,
                    client_secret: Configuration.GOOGLE_CLIENT_SECRET,
                    redirect_uri: Configuration.GOOGLE_REDIRECT_URI,
                    grant_type: 'authorization_code'
                  })
      end

      def fetch_profile(access_token)
        HTTP.get(PROFILE_ENDPOINT,
                 params: {
                   alt: 'json',
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
          oauth_provider: Models::User.oauth_providers[:google]
        }
      end
    end
  end
end
