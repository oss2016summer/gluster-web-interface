class HomeController < ApplicationController
  def index
    config = get_conf
    @current_dir = config["project_path"]
    file_directory(@current_dir)
  end
end
