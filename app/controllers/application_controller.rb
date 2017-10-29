class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ApplicationHelper
  include HomeHelper
  include VolumeHelper
  include NodeHelper

  def require_login
    unless user_signed_in?
      flash[:error] = "Please, Login required to use the service."
      redirect_to "/users/sign_in" # halts request cycle
    end
  end
end
