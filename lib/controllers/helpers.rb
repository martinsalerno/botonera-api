module Controllers
  module Helpers
    class MissingParameterError < StandardError; end

    def required!(*required_params)
      required_params.each do |required_param|
        raise MissingParameterError, required_param if params[required_param].nil?
      end
    end

    def serialize(status_code, obj, serializer: nil)
      if serializer.nil?
        return [status_code, obj.to_json]
      end

      payload = if obj.respond_to?(:each)
        obj.map { |k| serializer.new(k).as_json }
      else
        serializer.new(obj)
      end

      [status_code, payload.to_json]
    end
  end
end
