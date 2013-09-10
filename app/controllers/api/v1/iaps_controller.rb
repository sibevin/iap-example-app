class Api::V1::IapsController < ApplicationController
	before_filter :do_api_basic_auth
  protect_from_forgery except: :create
  respond_to :json

  INVALID_RETURN_CODE = :unprocessable_entity

  def create
    unless params['iap'] &&
           params['iap']['store'] &&
           params['iap']['receipt'] &&
           params['iap']['transaction'] &&
           params['iap']['sku'] &&
           params['iap']['pinfo'] &&
           params['iap']['dinfo']
			head INVALID_RETURN_CODE
      return 
    end
    result = IapHandler.check_request(params['iap'], current_user)
    case result[:status]
    when :success, :sandbox
      ActiveRecord::Base.transaction do
        InAppPurchase.create(result[:info][:iap_info])
        # TODO: Add a payment history.
        # TODO: Extend user's feature, it's your own business model.
      end
      returned_json = { status: 0 }
    when :duplicated
      returned_json = { status: 0 }
    when :invalid_request
			head INVALID_RETURN_CODE
      return
    when :failed
      FailedPurchase.create(result[:info][:iap_info])
      returned_json = { status: 1,
                        code: result[:code],
                        msg: result[:msg] }
    when :retry
      returned_json = { status: 2 }
    end
    render json: returned_json
  end
end
