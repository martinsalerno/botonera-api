class S3
  BUCKET = 'botonera-api'.freeze

  def self.presign_put_url(key)
  	presign(:put_object, key: key)
  end

  def self.presign_get_url(key)
  	presign(:get_object, key: key)
  end

  def self.presign(method, key)
  	presigner = Aws::S3::Presigner.new

  	presigner.presigned_url(method, bucket: BUCKET, key: key)
  end
end
