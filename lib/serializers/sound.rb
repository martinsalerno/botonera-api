module Serializers
  class Sound < ActiveModel::Serializer
    attributes :id, :name, :url

    def url
      object.download_link
    end
  end
end
