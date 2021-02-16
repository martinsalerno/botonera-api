FactoryBot.define do
  factory :keyboard, class: 'Models::Keyboard' do
    user

    sequence(:name) { |n| "test-keyboard-#{n}" }

    trait :empty do
      keys do
        Models::Keyboard::VALID_KEYS.each_with_object({}) { |key, accum| accum[key.to_sym] = {} }
      end
    end
  end
end
