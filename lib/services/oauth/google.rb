module OAuth
  class Google
    USER_INFO_ENDPOINT = 'https://www.googleapis.com/oauth2/v1/userinfo'.freeze
    AUTHORIZATION_API  = 'https://accounts.google.com/o/oauth2/v2/auth'.freeze

    class << self
      def fetch_user(code)
        token_response = fetch_access_token(code)
        return { error: token_response['error'] } if error?(token_response)

        profile_response = fetch_profile(token_response['access_token'])
        return { error: profile_response['error'] } if error?(profile_response)

        standarize_response(profile_response.merge(token_response))
      end

      def authorization_url
        params = {
          client_id: Configuration.GOOGLE_CLIENT_ID,
          redirect_uri: Configuration.GOOGLE_REDIRECT_URI,
          response_type: 'code',
          access_type: 'offline',
          scope: 'https://www.googleapis.com/auth/userinfo.profile',
          include_granted_scopes: true
        }

        "#{AUTHORIZATION_API}?#{params.to_query}"
      end

      private

      def fetch_access_token(code)
        HTTP.post('https://oauth2.googleapis.com/token',
                  json: {
                    code: code,
                    client_id: Configuration.GOOGLE_CLIENT_ID,
                    client_secret: Configuration.GOOGLE_CLIENT_SECRET,
                    redirect_uri: Configuration.GOOGLE_REDIRECT_URI,
                    grant_type: 'authorization_code'
                  }).parse('application/json')
      end

      def fetch_profile(access_token)
        HTTP.get(USER_INFO_ENDPOINT,
                 params: {
                   alt: 'json',
                   access_token: access_token
                 }).parse('application/json')
      end

      def standarize_response(hash)
        {
          email: hash['email'],
          oauth_user_id: hash['id'],
          oauth_user_name: hash['name'],
          oauth_user_picture: hash['picture'],
          oauth_refresh_token: hash['refresh_token'],
          oauth_provider: Models::User.oauth_providers[:google]
        }
      end

      def error?(hash)
        hash.include?('error')
      end
    end
  end
end
