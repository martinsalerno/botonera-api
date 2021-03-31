module Session
  class Cache
    CIPHER_ALGORITHM       = 'HS256'.freeze
    SECRET_KEY             = 'change-me'.freeze
    DEFAULT_EXPIRE_SECONDS = 1000

    class << self
      def tokenize(user)
        JWT.encode({ user_id: user.id }.to_json, SECRET_KEY, CIPHER_ALGORITHM).tap do |token|
          set(user.id, { token: token }.to_json)
        end
      end

      def fetch(token)
        user_id    = decode_user(token)
        redis_data = get(user_id)

        return nil if redis_data.nil?
        return nil if JSON.parse(redis_data)['token'] != token

        user_id.tap do |id|
          refresh(id)
        end
      rescue JWT::DecodeError
        nil
      end

      def remove(token)
        user_id = decode_user(token)

        redis.del(user_id)
      end

      def get(key)
        redis.get(key)
      end

      def refresh(key)
        redis.expire(key, DEFAULT_EXPIRE_SECONDS)
      end

      def set(key, value)
        redis.setex(key, DEFAULT_EXPIRE_SECONDS, value)
      end

      private

      def decode_user(token)
        user_data = JWT.decode(token, SECRET_KEY, true, { algorithm: CIPHER_ALGORITHM }).first

        JSON.parse(user_data)['user_id']
      end

      def redis
        @redis ||= Redis.new
      end
    end
  end
end
