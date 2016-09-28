class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    # protect_from_forgery with: :exception
    include ApplicationHelper
    include HomeHelper
    include VolumeHelper

    def require_login
        unless user_signed_in?
            flash[:error] = "Please, Login required to use the service."
            redirect_to "/users/sign_in" # halts request cycle
        end
    end

    def chdir
        @current_dir = params[:next_dir]
        puts "current_dir : " + @current_dir
        render :json => {
            :dir => @current_dir,
            :file_manager_table => file_manager_table(@current_dir),
            :disk_usage_table => disk_usage_table(@current_dir),
            :du => get_du(@current_dir),
        }
    end

    def rmdir
        file_name = params[:file_name]
        command = String.new
        command << "sudo rm -rf #{file_name}"
        puts command
        `#{command}`
    end

end
