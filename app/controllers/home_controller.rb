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
	 #  `cd /#{current_dir}`
	 # `cd /#{current_dir} & mkdir #{directory_name}`
	  puts "mkdir #{current_dir}/#{directory_name}"
	  `mkdir #{current_dir}/#{directory_name}`
	  #output = `sshpass -p#{@config["host_password"]} ssh #{@config["host_port"]} #{@config["host_user"]}@#{@config["host_ip"]} gluster volume delete #{volume_name}`
    redirect_to '/home/index'
  end
end
