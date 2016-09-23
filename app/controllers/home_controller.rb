class HomeController < ApplicationController
    before_action :require_login
    
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
        # make directory
        command = String.new
        command << "sudo mkdir #{current_dir}/#{directory_name}"
        puts command
        `#{command}`
        redirect_to '/home/index'
    end
    
    
    def delete_file
        file_name = params[:file_name]
        # delete file
        command = String.new
        command << "sudo rm -rf #{file_name}"
        puts command
         `#{command}`
        redirect_to '/home/index'
    end

end
