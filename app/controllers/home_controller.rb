class HomeController < ApplicationController
  def index
    @current_dir = "/mnt"
    file_directory(@current_dir)
  end

  def file_download
      @file_name = params[:file_name].gsub(" ", "/")
      if !@file_name.nil?
          send_file @file_name
      else
          puts "file name is nil"
          redirect_to '/home/index'
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
