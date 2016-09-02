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
        @config["host_port"] = "-p " + t.split("host_port=")[1] + " "
      elsif t.include? "host_password="
        @config["host_password"] = t.split("host_password=")[1]
      end
    end
    return @config
  end
  
end
