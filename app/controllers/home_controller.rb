class HomeController < ApplicationController
  def index
    config = get_conf
    #@current_dir = config["project_path"]
    @current_dir = "/mnt"
    file_directory(@current_dir)
  end
  
  
  def make_directory
	  current_dir = params[:current_dir]
	  directory_name = params[:directory_name]
	  `mkdir #{current_dir}/#{directory_name}`
	  redirect_to '/home/index'
  end
end
