class StoreSkucode < ActiveRecord::Base
  include ActiveRecordInitExtension

  belongs_to :sku

  DEFAULT_SEEDS = {
    1 => {
      sku_id: 1,
      storecode: IapStore::AppStore.storecode,
      skucode: ENV['APPSTORE_SKUCODE_100_COIN']
    },
    2 => {
      sku_id: 1,
      storecode: IapStore::GooglePlay.storecode,
      skucode: ENV['GOOGLEPLAY_SKUCODE_100_COIN']
    }
  }
  validates :storecode,
            uniqueness: { scope: :sku_id,
                          message: "storecode should be unique per sku." }
  def match_code?(code)
    skucode.split(',').include?(code)
  end
end
