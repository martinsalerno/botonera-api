describe Controllers::Application do
  describe 'GET /me' do
    include_context 'authenticated user'

    let(:expected_fields) do
      %w[id email oauth_provider oauth_user_picture default_keyboard keyboards]
    end

    before do
      get '/me', '{}', auth_header
    end

    it 'returns the user data' do
      expect(parsed_body).to include(*expected_fields)
    end
  end
end
