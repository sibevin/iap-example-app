# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :store_skucode do
    sku_id 1
    storecode "afs"
    skucode "a_fake_store_sku_code"
  end
end
