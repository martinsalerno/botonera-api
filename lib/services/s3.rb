class S3
  BUCKET = 'botonera-api'.freeze

  class << self
    def presign_put_url(key)
      presign(:put_object, key)
    end

    def presign_get_url(key, filename: nil)
      presign(:get_object, key, filename: filename)
    end

    private

    def presign(method, key, filename: nil)
      presigner = Aws::S3::Presigner.new

      opts = {
        bucket: BUCKET,
        key: key
      }

      if filename
        opts.merge!(response_content_disposition: "attachment; filename=#{filename}")
      end

      presigner.presigned_url(method, opts)
    end
  end
end
