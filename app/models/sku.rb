class Sku < ActiveRecord::Base
  include ActiveRecordInitExtension

  belongs_to :item
  has_many :store_skucodes
  has_many :in_app_purchases

  DEFAULT_SEEDS = {
    1 => {
      item_id: 1,
      name: 'A coin package with 100 coins inside.',
      skucode: "#{ENV['APP_CODE']}#{ENV['SKUCODE_100_COIN']}",
      amount: 100,
      price: 199,
      onshelf: false
    },
    2 => {
      item_id: 1,
      name: 'A coin package with 500 coins inside.(20% off !!)',
      skucode: "#{ENV['APP_CODE']}#{ENV['SKUCODE_500_COIN']}",
      amount: 500,
      price: 799,
      onshelf: false
    }
  }

  def store_skucode_match?(storecode, code)
    unless sscode = store_skucodes.find_by_storecode(storecode)
      raise "Cannot find the store_skucode with the given store #{storecode}."
    else
      sscode.match_code?(code)
    end
  end
end
