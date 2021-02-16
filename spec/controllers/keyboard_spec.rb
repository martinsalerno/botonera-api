describe Controllers::Application do
  include_context 'authenticated user'

  let!(:keyboard) { create(:keyboard, :empty, user: user) }

  let(:keyboard_hash) do
    { id: keyboard.id, name: keyboard.name, keys: keyboard.keys }
  end

  describe 'GET /keyboards' do
    let(:expected_response) { [keyboard_hash].to_json }

    before do
      get '/keyboards', nil, auth_header
    end

    it 'returns the user keyboards' do
      expect(last_response.body).to eq(expected_response)
    end
  end

  describe 'POST /keyboards' do
    before do
      post '/keyboards', payload.to_json, auth_header
    end

    context 'when name is included' do
      let(:new_keyboard)      { user.keyboards.reload.last }
      let(:payload)           { { name: 'test-brand-new-keyboard' } }

      let(:expected_response) do
        { id: new_keyboard.id, name: new_keyboard.name, keys: new_keyboard.keys }.to_json
      end

      it 'returns the keyboard' do
        expect(last_response.body).to eq(expected_response)
      end
    end

    context 'when name is not included' do
      let(:payload)           { {} }
      let(:expected_response) { { error: 'name' }.to_json }

      it 'returns an error' do
        expect(last_response.body).to eq(expected_response)
      end
    end
  end

  describe 'GET /keyboards/:keyboard_id' do
    let(:expected_response) { keyboard_hash.to_json }

    before do
      get "/keyboards/#{keyboard.id}", {}, auth_header
    end

    it 'returns the keyboard' do
      expect(last_response.body).to eq(expected_response)
    end
  end

  describe 'PATCH /keyboards/:keyboard_id' do
    before do
      patch "/keyboards/#{keyboard.id}", payload.to_json, auth_context[:headers]
    end

    context 'when name is included' do
      let(:payload)           { { name: 'test-new-keyboard' } }
      let(:expected_response) { keyboard_hash.merge(name: 'test-new-keyboard').to_json }

      it 'returns an error' do
        expect(last_response.body).to eq(expected_response)
      end
    end

    context 'when name is not included' do
      let(:payload)           { {} }
      let(:expected_response) { { error: 'name' }.to_json }

      it 'returns the patched keyboard' do
        expect(last_response.body).to eq(expected_response)
      end
    end
  end

  describe 'POST /keyboards/:keyboard_id/keys' do
    let(:sound) { user.sounds.create!(name: 'test-sound', path: '/test/sound') }

    before do
      post "/keyboards/#{keyboard.id}/keys", payload.to_json, auth_header
    end

    context 'when the key is valid' do
      let(:payload) { { key: 'a', sound_id: sound.id } }
      let(:expected_keys) do
        keyboard_hash[:keys].merge({ 'a': { sound_id: sound.id, sound_name: sound.name } })
      end
      let(:expected_response) { keyboard_hash.merge(keys: expected_keys).to_json }

      it 'returns the updated keyboard' do
        expect(last_response.body).to eq(expected_response)
      end
    end

    context 'when the key is invalid' do
      let(:payload)           { { key: '>', sound_id: sound.id } }
      let(:expected_response) { { error: 'invalid_key' }.to_json }

      it 'returns the updated keyboard' do
        expect(last_response.body).to eq(expected_response)
      end
    end
  end
end
