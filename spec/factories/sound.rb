FactoryBot.define do
  factory :sound, class: 'Models::Sound' do
    user

    sequence(:name) { |n| "test-sound-#{n}" }
    path            { "#{user.id}/sounds/#{name}" }
  end
end
