class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    # protect_from_forgery with: :exception

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

    def file_directory(dir)
        @current_dir = dir
        dir_list = `ls #{@current_dir} -l`
        parsing_list = dir_list.split("\n")
        @files = Array.new
        file = Hash.new
        
        @total_list = parsing_list[0]
        for t in 1..(parsing_list.length-1)
            parsing_file = parsing_list[t].split(" ")
            file["auth"] = parsing_file[0]
            file["size"] = parsing_file[4]
            file["date"] = parsing_file[5] + " " + parsing_file[6] + " " + parsing_file[7]
            file["name"] = parsing_file[8]
            @files << file
            file = Hash.new
        end
        puts @files
        return @files
    end

    def checkDir
        files = file_directory(params[:path])
        render :json => {:file => files , :current => @current_dir}
    end
end
