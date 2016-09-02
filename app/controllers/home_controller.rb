class HomeController < ApplicationController
  def index
    config = get_conf
    @current_dir = config["project_path"]
  end
end
