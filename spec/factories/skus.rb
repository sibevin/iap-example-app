# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sku do
    item_id 1
    name "A test sku"
    skucode "CFF61522C6FEE759"
    price 1
    amount 1
  end
end
