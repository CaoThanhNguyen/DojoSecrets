FactoryBot.define do
  factory :secret do
    user { nil }
    content { "My secret" }
  end
end
