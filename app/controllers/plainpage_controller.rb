class PlainpageController < ApplicationController

  def index
    unless user_signed_in?
	redirect_to '/users/sign_in'
    end
    flash[:success ] = "Success Flash Message: Welcome to GentellelaOnRails"
    #other alternatives are
    # flash[:warn ] = "Israel don't quite like warnings"
    #flash[:danger ] = "Naomi let the dog out!"
  end

end
