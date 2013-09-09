module IapHandler
  class << self
    def check_request(params, user, masked = false)
      iap_info = {
        user_id: user.id,
        store: params['store'],
        receipt: params['receipt'],
        transaction_val: params['transaction'],
        pinfo: params['pinfo'],
        dinfo: params['dinfo']
      }
      unless iap_info[:pinfo] =~ /price=(.*),currency=(.*),amount=(.*)/
        raise AppError::IapError.new(20001,
          "Purchase information #{iap_info[:pinfo]} format is incorrect")
      end
      unless iap_info[:dinfo] =~ /appver=(.*),platform=(.*),os=(.*),osver=(.*)/
        raise AppError::IapError.new(20002,
          "Device information #{iap_info[:dinfo]} format is incorrect")
      end
      unless IapStore.support?(iap_info[:store])
        raise AppError::IapError.new(20003, "Unknown store #{iap_info[:store]}.")
      end
      if iap_info[:transaction_val] =~ /urus/
        raise AppError::IapError.new(20004, nil, { iap_info: iap_info })
      end
      unless sku = Sku.find_by_skucode(params['sku'])
        raise AppError::IapError.new(20005)
      end
      iap_info.merge!(sku_id: sku.id)
      if iap = InAppPurchase.where(['store = ? AND transaction_val = ?',
                                   iap_info[:store], iap_info[:transaction_val]]).first
        if iap.user_id != user.id
          raise AppError::IapError.new(20006,
            "An existing IAP with the wrong user.(#{iap.user_id} -> #{user.id})",
            { iap_info: iap_info })
        elsif iap.sku_id != sku.id
          raise AppError::IapError.new(20007,
            "An existing IAP with the wrong sku.(#{iap.sku_id} -> #{sku.id})",
            { iap_info: iap_info })
        else
          raise AppError::IapError.new(20100)
        end
      else
        result = IapStore.check_tpv(iap_info[:store], sku, iap_info)
        iap_info.merge!({
          purchased_at: result[:purchased_at],
          expires_at: result[:expires_at]
        })
        succ = AppError::IapError.new(:success, nil, { iap_info: iap_info })
        return succ.einfo
      end
    rescue AppError::IapError => e
      raise e if e.status == :internal_error
      return e.einfo(masked)
    end
  end
end
