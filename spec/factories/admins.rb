FactoryGirl.define do
  factory :admin do
    email { Faker::Internet.email }
    encrypted_password { Faker::Lorem.characters(32) }
    reset_password_token { Faker::Lorem.characters(32) }
    reset_password_sent_at { 
      Faker::Time.between(DateTime.now - 100, DateTime.now) }
    remember_created_at { 
      Faker::Time.between(DateTime.now - 200, DateTime.now - 100) }
    sign_in_count 0
    current_sign_in_at { 
      Faker::Time.between(DateTime.now - 100, DateTime.now) }
    last_sign_in_at { Faker::Time(DateTime.now) }
    current_sign_in_ip { Faker::Internet.ip_v4_address }
    last_sign_in_ip { Faker::Internet.ip_v4_address }
  end

end
