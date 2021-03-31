module Controllers
  module Helpers
    class MissingParameterError < StandardError; end
    class InvalidKeyError < StandardError; end

    def current_user
      @current_user ||= fetch_user
    end

    def user_logged?
      !current_user.nil?
    end

    def params_body
      @params_body ||= JSON.parse(request&.body&.try(:read) || '{}', symbolize_names: true)
    end

    def required!(*required_params)
      required_params.each do |required_param|
        if params[required_param].nil? && params_body[required_param].nil?
          raise MissingParameterError, required_param
        end
      end
    end

    def serialize(status_code, obj, serializer: nil)
      return [status_code, obj.try(:to_json)] if serializer.nil?

      payload = if obj.respond_to?(:each)
                  obj.map { |k| serializer.new(k).as_json }
                else
                  serializer.new(obj)
                end

      [status_code, payload.to_json]
    end

    private

    def fetch_user
      return nil if token.nil?

      user_id = Session::Cache.fetch(token)
      return nil if user_id.nil?

      Models::User.find_by(id: user_id)
    end

    def token
      request.env[Controllers::Application::TOKEN_HEADER]
    end
  end
end
