module OAuth
  class Base
    class << self
      def fetch_user(code)
        token_response = fetch_access_token_response(code)

        return { error: token_response['error'] } if error?(token_response)

        puts token_response['access_token']
        profile_response = fetch_profile_response(token_response['access_token'])
        puts profile_response
        return { error: profile_response['error'] } if error?(profile_response)

        find_or_create_user(profile_response.merge(token_response))
      end

      private

      def fetch_access_token_response(code)
        fetch_access_token(code).parse('application/json')
      end

      def fetch_profile_response(access_token)
        fetch_profile(access_token).parse('application/json')
      end

      def find_or_create_user(response)
        params = standarize_response(response)

        user = Models::User.find_by(email: params[:email], oauth_user_id: params[:oauth_user_id])
        return user if user.present?

        Models::User.create!(
          email: params[:email],
          oauth_user_id: params[:oauth_user_id],
          oauth_user_name: params[:oauth_user_name],
          oauth_user_picture: params[:oauth_user_picture],
          ouath_refresh_token: params[:ouath_refresh_token],
          oauth_provider: params[:oauth_provider]
        ).tap(&:create_default_keyboard!)
      end

      def error?(response)
        response.include?('error')
      end
    end
  end
end
