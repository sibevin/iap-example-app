module IapStore
  class GooglePlay < Base
    def self.storecode
      'ggp'
    end

    def check_tpv(sku, iap_info)
      # TODO
      raise "IapStore::GooglePlay.check_tpv is not implemented yet."
    end

    def show_raw_result(receipt, sandbox = false)
      # TODO
      raise "IapStore::GooglePlay.show_raw_result is not implemented yet."
    end
  end
end
