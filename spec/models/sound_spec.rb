describe Models::Sound, type: :model do
  it { is_expected.to belong_to(:user) }
end
