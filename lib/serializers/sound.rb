module Serializers
  class Sound < ActiveModel::Serializer
    attributes :id, :name, :url

    def url
      S3.presign_get_url(self.object.path)
    end
  end
end
