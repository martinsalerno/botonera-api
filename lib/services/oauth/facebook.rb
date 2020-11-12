module OAuth
  class Facebook
    AUTHORIZATION_API = 'https://www.facebook.com/v8.0/dialog/oauth'.freeze

    class << self
      def fetch_user(code)
        token_response = fetch_access_token(code)
        puts token_response
        return { error: token_response['error'] } if error?(token_response)

        profile_response = fetch_profile(token_response['access_token'])
        puts profile_response
        return { error: profile_response['error'] } if error?(profile_response)

        standarize_response(profile_response.merge(token_response))
      end

      def authorization_url
        params = {
          client_id: Configuration.FACEBOOK_CLIENT_ID,
          redirect_uri: Configuration.FACEBOOK_REDIRECT_URI,
          response_type: 'code',
          scope: 'email user_photos'
        }

        "#{AUTHORIZATION_API}?#{params.to_query}"
      end

      private

      def fetch_access_token(code)
        HTTP.post('https://graph.facebook.com/v8.0/oauth/access_token',
                  json: {
                    code: code,
                    client_id: Configuration.FACEBOOK_CLIENT_ID,
                    client_secret: Configuration.FACEBOOK_CLIENT_SECRET,
                    redirect_uri: Configuration.FACEBOOK_REDIRECT_URI
                  }).parse('application/json')
      end

      def fetch_profile(access_token)
        HTTP.get('https://graph.facebook.com/me',
                 params: {
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
          oauth_provider: Models::User.oauth_providers[:facebook]
        }
      end

      def error?(hash)
        hash.include?('error')
      end
    end
  end
end
