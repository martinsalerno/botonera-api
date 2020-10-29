describe Models::Keyboard, type: :model do
  it { is_expected.to belong_to(:user) }
end
