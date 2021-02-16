describe Session::Cache do
  let(:user)  { create(:user) }
  let(:redis) { Redis.new }

  before(:each) do
    redis.del(user.id)
  end

  describe '.tokenize' do
    it 'encodes a token for the given user' do
      expect(described_class.tokenize(user)).not_to be_nil
    end

    it 'saves the token in redis' do
      expect { described_class.tokenize(user) }.to change { Redis.new.get(user.id) }.from(nil)
    end
  end

  describe '.fetch' do
    context 'when the token is valid' do
      let(:token) { described_class.tokenize(user) }

      before do
        allow(described_class).to receive(:refresh).and_call_original
      end

      it 'decodes the user id' do
        expect(described_class.fetch(token)).to eq(user.id)
      end

      it 'refreshes the user token' do
        described_class.fetch(token)

        expect(described_class).to have_received(:refresh)
      end
    end

    context 'when the token is invalid' do
      let(:invalid_token) { 'invalid-token' }

      it 'returns nil' do
        expect(described_class.fetch(invalid_token)).to be_nil
      end
    end
  end
end
