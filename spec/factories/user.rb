FactoryBot.define do
  factory :user, class: 'Models::User' do
    sequence(:email) { |n| "test-email-#{n}" }

    oauth_provider { Models::User.oauth_providers[:google] }
    sequence(:oauth_user_id)       { |n| "test-user-id-#{n}"       }
    sequence(:oauth_user_name)     { |n| "test-user-name-#{n}"     }
    sequence(:oauth_user_picture)  { |n| "test-user-picture-#{n}"  }
    sequence(:ouath_refresh_token) { |n| "test-refresh-token-#{n}" }
  end
end
