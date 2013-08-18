class Item < ActiveRecord::Base
  include ActiveRecordInitExtension

  has_many :skus

  DEFAULT_SEEDS = {
    1 => {
      name: 'Coin'
    }
  }

  def set_onshelf!(turn_on = true)
    skus.each do |sku|
      sku.update_attributes!(onshelf: turn_on) if sku.onshelf != turn_on
    end
  end
end
