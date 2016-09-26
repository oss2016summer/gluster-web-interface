class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    # protect_from_forgery with: :exception
    include ApplicationHelper

    def require_login
        unless user_signed_in?
            flash[:error] = "Please, Login required to use the service."
            redirect_to "/users/sign_in" # halts request cycle
        end
    end

    def get_df
        df = Array.new
        df_each = Hash.new
        command = String.new
        command << "df -hP"
        puts command
        output = `#{command}`.split("\n")
        output.each do |t|
            next if t.equal? output.first
            s = t.split(' ')
            df_each['Filesystem'] = s[0]
            df_each['Size'] = s[1]
            df_each['Used'] = s[2]
            df_each['Avail'] = s[3]
            df_each['Use%'] = s[4]
            df_each['Mounted on'] = s[5]
            df << df_each
            df_each = Hash.new
        end
        return df
    end

    def chdir
        @current_dir = params[:next_dir]
        puts "current_dir : " + @current_dir
        render :json => {:dir => @current_dir}
    end

    def rmdir
        file_name = params[:file_name]
        command = String.new
        command << "sudo rm -rf #{file_name}"
        puts command
         `#{command}`
    end

end
