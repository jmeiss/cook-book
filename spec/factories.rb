FactoryGirl.define do
  
  factory :user do
    sequence(:first_name) { |n| "first name #{n}" }
    sequence(:last_name)  { |n| "last name #{n}" }
    sequence(:email)      { |n| "username#{n}@example.com" }
    password 'password'
    password_confirmation { |u| u.password }
  end

end
