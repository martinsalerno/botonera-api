describe OAuth::Google do
  describe '.authorization_url' do
    it 'returns the full authorization url' do
      expect(described_class.authorization_url)
        .to  include(described_class::AUTHORIZATION_ENDPOINT)
        .and include({ client_id: Configuration.GOOGLE_CLIENT_ID }.to_query)
        .and include({ redirect_uri: Configuration.GOOGLE_REDIRECT_URI }.to_query)
        .and include('response_type')
        .and include('access_type')
        .and include('scope')
    end
  end

  describe '.fetch_user' do
    let(:token_response) do
      {
        access_token: 'T-6eqqh2gj47R6s', expires_in: 3599, refresh_token: '1/cqmS_jF2Y',
        scope: 'openid', token_type: 'Bearer', id_token: 'xaJRuvUVHGQ'
      }
    end
    let(:profile_response) do
      {
        id: 419, email: 'marting@gmail.com', verified_email: true,
        name: 'Martin', given_name: 'Martin',
        family_name: 'Salerno', picture: 'https://lh3.googleusercontent.com/a-/4FzOc=s96-c',
        locale: 'es-419'
      }
    end
    let(:code) { '444' }

    before do
      stub_request(:post, described_class::TOKEN_ENDPOINT).with(
        body: hash_including(code: code)
      ).to_return(body: token_response.to_json)

      stub_request(:get, described_class::PROFILE_ENDPOINT).with(
        query: { access_token: token_response[:access_token], alt: 'json' }
      ).to_return(body: profile_response.to_json)
    end

    context 'when the user is new' do
      before do
        described_class.fetch_user(code)
      end

      it 'creates a new user' do
        expect(Models::User.find_by(email: profile_response[:email])).to be_present
      end
    end

    context 'when the user already exists' do
      it 'fetches the user' do
      end
    end
  end
end
