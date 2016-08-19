class PlainpageController < ApplicationController
  before_action :require_login
  
  def index
    flash[:success ] = "Success Flash Message: Welcome to GentellelaOnRails"
    #other alternatives are
    # flash[:warn ] = "Israel don't quite like warnings"
    #flash[:danger ] = "Naomi let the dog out!"
  end
  
  
  # CHECK SIGNED IN FOR USING THE SERVICE
  def require_login
    unless user_signed_in?
      flash[:danger] = "서비스 이용을 위한 로그인이 필요합니다."
      redirect_to '/users/sign_in' # halts request cycle
    end
  end
end
