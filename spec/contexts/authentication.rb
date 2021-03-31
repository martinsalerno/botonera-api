shared_context 'authenticated user' do |user|
  let(:auth_context) do
    user = create(:user)

    {
      user:    user,
      headers: {
        Controllers::Application::TOKEN_HEADER => Session::Cache.tokenize(user)
      }
    }
  end

  let(:user)        { auth_context[:user] }
  let(:auth_header) { auth_context[:headers] }
end
