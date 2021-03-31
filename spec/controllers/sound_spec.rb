describe Controllers::Application do
  include_context 'authenticated user'

  let!(:sound) { create(:sound, user: user) }

  let(:sound_hash) do
    [{ id: sound.id, name: sound.name, url: sound.download_link }]
  end

  before do
    allow(S3).to receive(:presign_put_url).and_return('presigned-put-url')
    allow(S3).to receive(:presign_get_url).and_return('presigned-get-url')
  end

  describe 'GET /sounds' do
    let(:expected_response) { sound_hash.to_json }

    before do
      get '/sounds', {}.to_json, auth_header
    end

    it 'return the user sounds' do
      expect(last_response.body).to eq(expected_response)
    end
  end

  describe 'POST /sounds' do
    let(:payload) { { name: 'test-sound' } }

    before do
      post '/sounds', payload.to_json, auth_header
    end

    it 'returns the new sound' do
      expect(parsed_body).to include('id', 'name', 'url')
    end
  end

  describe 'POST /sounds/new_url' do
    let(:payload) { { name: 'brand-new-sound' } }

    before do
      post '/sounds/new_url', payload.to_json, auth_header
    end

    it 'returns the presigned url' do
      expect(parsed_body).to include('url')
    end
  end

  describe 'PATCH /sounds/:sound_id' do
    let(:sound_name)      { 'start-sound-name' }
    let(:sound_to_update) { create(:sound, user: user, name: sound_name) }
    let(:payload)         { { name: 'new-sound-name' } }

    let(:expected_response) do
      { id: sound_to_update.id, name: payload[:name], url: sound_to_update.download_link }.to_json
    end

    before do
      patch "/sounds/#{sound_to_update.id}", payload.to_json, auth_header
    end

    it 'returns the updated sound' do
      expect(last_response.body).to eq(expected_response)
    end
  end
end
