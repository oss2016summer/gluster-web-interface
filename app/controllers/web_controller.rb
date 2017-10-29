class WebController < ApplicationController
  before_action :require_login
end
