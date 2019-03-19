FactoryBot.define do
  factory :user do
    name { "Blue Sky" }
    email { "blue.sky@gmail.com" }
    password { "password" }
    password_confirmation {"password"}
  end
end
