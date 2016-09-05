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
	  puts "mkdir #{current_dir}/#{directory_name}"
	  `mkdir #{current_dir}/#{directory_name}`
	  redirect_to '/home/index'
  end
  
  
  def delete_file
	  file_name = params[:file_name]
	  puts "rm #{file_name} -rf"
	  `rm #{file_name} -rf`
	  redirect_to '/home/index'
  end
end
