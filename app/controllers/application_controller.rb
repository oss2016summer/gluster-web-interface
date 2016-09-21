class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  def get_conf
    @config = Hash.new
    
    output = `cat configure.conf`.split("\n")
    output.each do |t|
      if t.include? "project_path="
	    @config["project_path"] = t.split("project_path=")[1]
      elsif t.include? "server_name="
        @config["server_name"] = t.split("server_name=")[1]
      elsif t.include? "host_user="
        @config["host_user"] = t.split("host_user=")[1]
      elsif t.include? "host_ip="
        @config["host_ip"] = t.split("host_ip=")[1]
      elsif t.include? "host_port=" and !t.split("host_port=")[1].nil?
        @config["host_port"] = t.split("host_port=")[1] + " "
      elsif t.include? "host_password="
        @config["host_password"] = t.split("host_password=")[1]
      end
    end
    
    
    return @config
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
