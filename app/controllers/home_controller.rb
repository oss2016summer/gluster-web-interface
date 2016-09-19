class HomeController < ApplicationController
  def index
    config = get_conf
    #@current_dir = config["project_path"]
    @current_dir = "/mnt"
    file_directory(@current_dir)
  end

  def file_download
      @file_name = params[:file_name]
      puts "file_name: " + @file_name
      if File.exist?(@file_name)
          #File.delete(@file_name)
          puts "file exist!!"
          send_file(@file_name)
          puts "send success"
      end
  end

  def make_directory
	  current_dir = params[:current_dir]
	  directory_name = params[:directory_name]
	  puts "mkdir #{current_dir}/#{directory_name}"
	  `sudo mkdir #{current_dir}/#{directory_name}`
	  redirect_to '/home/index'
  end

  def delete_file
	  file_name = params[:file_name]
	  puts "rm #{file_name} -rf"
	  `sudo rm #{file_name} -rf`
	  redirect_to '/home/index'
  end
end
