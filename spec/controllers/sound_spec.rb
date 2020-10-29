describe Controllers::Application do
  include Controllers::Test

  let!(:user) do
    Models::User.create!(email: 'test@gmail.com')
  end

  let!(:sound) do
    Models::Sound.create(user_id: user.id, name: 'test.mp3', path: '/1/sounds/test.mp3')
  end

  let(:sound_hash) do
    { id: sound.id, name: sound.name, url: nil }
  end

  describe 'GET /:user_id/sounds' do
    let(:expected_response) { sound_hash.to_json }

    before do
      get "#{user.id}/sounds"
    end

    it 'return the user sounds' do
      expect(last_response.body).to eq(expected_response)
    end
  end

  describe 'POST /:user_id/sounds' do
    before do
      post "#{user.id}/sounds", payload
    end
  end

  describe 'POST /:user_id/sound_url' do
    before do
      post "#{user.id}/sound_url", payload
    end
  end

  describe 'PATCH /:user_id/sounds/:sound_id' do
    before do
      patch "#{user.id}/sounds/:sound_id", payload
    end
  end
end
