module Models
  class Sound < ActiveRecord::Base
    belongs_to :user

    def download_link
      S3.presign_get_url(path, filename: name)
    end
  end
end
