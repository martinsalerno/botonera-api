describe Controllers::Application do
  include Controllers::Test

  let!(:user) do
    Models::User.create(email: 'test@gmail.com')
  end

  let!(:keyboard) do
    Models::Keyboard.create(user_id: user.id, name: 'test-keyboard')
  end

  let(:kerboard_hash) do
    { id: keyboard.id, name: keyboard.name, keys: keyboard.keys }
  end

  describe 'GET /:user_id/keyboards' do
    let(:expected_response) { [kerboard_hash].to_json }

    before do
      get "#{user.id}/keyboards"
    end

    it 'returns the user keyboards' do
      expect(last_response.body).to eq(expected_response)
    end
  end

  describe 'POST /:user_id/keyboards' do
    before do
      post "#{user.id}/keyboards", payload
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
      let(:payload)           { nil }
      let(:expected_response) { { error: 'name' }.to_json }

      it 'returns an error' do
        expect(last_response.body).to eq(expected_response)
      end
    end
  end

  describe 'GET /:user_id/keyboards/:keyboard_id' do
    let(:expected_response) { kerboard_hash.to_json }

    before do
      get "#{user.id}/keyboards/#{keyboard.id}"
    end

    it 'returns the keyboard' do
      expect(last_response.body).to eq(expected_response)
    end
  end

  describe 'PATCH /:user_id/keyboards/:keyboard_id' do
    before do
      patch "#{user.id}/keyboards/#{keyboard.id}", payload
    end

    context 'when name is included' do
      let(:payload)           { { name: 'test-new-keyboard' } }
      let(:expected_response) { kerboard_hash.merge(name: 'test-new-keyboard').to_json }

      it 'returns an error' do
        expect(last_response.body).to eq(expected_response)
      end
    end

    context 'when name is not included' do
      let(:payload)           { nil }
      let(:expected_response) { { error: 'name' }.to_json }

      it 'returns the patched keyboard' do
        expect(last_response.body).to eq(expected_response)
      end
    end
  end

  describe 'POST /:user_id/keyboards/:keyboard_id/keys' do
    let(:sound) { user.sounds.create!(name: 'test-sound', path: '/test/sound') }

    before do
      post "#{user.id}/keyboards/#{keyboard.id}/keys", payload
    end

    context 'when the key is valid' do
      let(:payload) { { key: 'a', sound_id: sound.id } }
      let(:expected_response) do
        kerboard_hash.merge(keys: { 'a': { sound_id: sound.id, sound_name: sound.name } }).to_json
      end

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
