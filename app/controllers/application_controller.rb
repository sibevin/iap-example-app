class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

	def do_api_basic_auth
		authenticate_or_request_with_http_basic("IAP Example App") do |account, pw|
			@current_user = nil
      unless user = User.find_by_email(account)
        raise AppError::UserError.new(10001)
      end
      unless user.valid_password?(pw)
        raise AppError::UserError.new(10002)
      end
      @current_user = user
      return
    end
  rescue AppError::UserError => e
    render :json => { :error => { :code => e.code } }
	end
end
