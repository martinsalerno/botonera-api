describe OAuth::Facebook do
  describe '.authorization_url' do
    it 'returns the full authorization url' do
      expect(described_class.authorization_url)
        .to  include({ client_id: Configuration.FACEBOOK_CLIENT_ID }.to_query)
        .and include({ redirect_uri: Configuration.FACEBOOK_REDIRECT_URI }.to_query)
        .and include('response_type')
        .and include('scope')
    end
  end

  describe '.fetch_user' do
    let(:token_response) do
      { access_token: 'AEasd4hG7reBw', token_type: 'bearer', expires_in: 5_183_967 }
    end

    let(:profile_response) do
      { name: 'Martin', email: 'marting@gmail.com', id: '10224747407740682' }
    end
    let(:code) { '444' }

    before do
      stub_request(:post, described_class::TOKEN_ENDPOINT).with(
        body: hash_including(code: code)
      ).to_return(body: token_response.to_json)

      stub_request(:get, described_class::PROFILE_ENDPOINT).with(
        query: { access_token: token_response[:access_token] }
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
