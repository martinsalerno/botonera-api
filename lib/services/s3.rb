class S3
  BUCKET = 'botonera-api'.freeze

  class << self
    def presign_put_url(key)
      presign(:put_object, key)
    end

    def presign_get_url(key)
      presign(:get_object, key)
    end

    private

    def presign(method, key)
      presigner = Aws::S3::Presigner.new

      presigner.presigned_url(method, bucket: BUCKET, key: key)
    end
  end
end
