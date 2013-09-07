module IapStore
  class Base
    def check_tpv(sku, iap_info)
      raise 'You should implement check_tpv method in your IapStore-based class.'
    end

    def show_raw_result(receipt)
      raise 'You should implement show_raw_result method in your IapStore-based class.'
    end
  end
end
