# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :in_app_purchase do
    user_id 1
    sku_id 1
    store "MyString"
    receipt "MyText"
    transaction_val "MyString"
    pinfo "MyString"
    dinfo "MyString"
    error_code "MyString"
    purchased_at "2013-08-27 09:53:31"
    expires_at "2013-08-27 09:53:31"
    cancelled_at "2013-08-27 09:53:31"
    refunded_at "2013-08-27 09:53:31"
  end
end
