describe Models::User, type: :model do
  it { is_expected.to have_many(:sounds) }
  it { is_expected.to have_many(:keyboards) }
end
