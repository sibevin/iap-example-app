# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :failed_purchase do
    user_id 1
    sku_id 1
    store "MyString"
    receipt "MyText"
    transaction_val "MyString"
    pinfo "MyString"
    dinfo "MyString"
    error_code "MyString"
  end
end
