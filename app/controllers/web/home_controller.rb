class Web::HomeController < WebController
    def index
        @current_dir = "/mnt"
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

    def chdir
        @current_dir = params[:next_dir]
        puts "current_dir : " + @current_dir
        render :json => {
            :dir => @current_dir,
            :file_manager_table => html_file_manager_table(@current_dir),
            :disk_usage_table => html_disk_usage_table(@current_dir),
            :du => get_du(@current_dir),
        }
    end

    def rmdir
        @current_dir = params[:current_dir]
        file_name = params[:target]
        command = String.new
        command << "sudo rm -rf #{file_name}"
        puts command
        `#{command}`
        render :json => {
            :dir => @current_dir,
            :file_manager_table => html_file_manager_table(@current_dir),
            :disk_usage_table => html_disk_usage_table(@current_dir),
            :du => get_du(@current_dir),
        }
    end
end
