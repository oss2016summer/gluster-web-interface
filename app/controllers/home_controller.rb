class HomeController < ApplicationController
  def index
    config = get_conf
#    @current_dir = config["project_path"]
    @current_dir = "~"
    file_directory(@current_dir)
  end
end
