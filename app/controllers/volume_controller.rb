class VolumeController < ApplicationController
  helper_method :file_directory
  
  def index
    @config = get_conf
    #project_path = String.new
    #@conf_list.each do |t|
    #  if t.include? "project_path="
    #    project_path = t.split("project_path=")[1]
    #  end
    #end
    
    #file_directory(project_path)
    
    
    puts  @config["project_path"]
    puts  @config["server_name"]
    puts  @config["host_user"]
    puts  @config["host_ip"]
    puts  @config["host_port"]
    puts  @config["host_password"]
    file_directory(@config["project_path"])
    
    
    @volumes = Array.new
    volume = Hash.new
    
    if get_info.blank?
      flash[:danger] = "Check Server"
    else
      output = get_info.split("\n")
      for t in 1..(output.length-1)
         if output[t].include? ":" 
           temp = output[t].split(":")
           volume[temp[0]] = temp[1]
         else  
           @volumes << volume
           volume = Hash.new
         end
      end
      @volumes << volume
      puts @volumes
    end
  end

  def get_conf
    @config = Hash.new
    #host_user = "root"
    #host_ip = "127.0.0.1"
    #host_password = "secret"
    #host_port = ""
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
    #return `cat configure.conf`.split("\n")
  end

  def get_info
    #host_user = "root"
    #host_ip = "127.0.0.1"
    #host_password = "secret"
    #host_port = ""
    @config = get_conf
   # @conf_list.each do |t|
   #   if t.include? "host_name="
   #     host_user = t.split("host_user=")[1]
   #   elsif t.include? "host_ip="
   #     host_ip = t.split("host_ip=")[1]
   #   elsif t.include? "host_port=" and !t.split("host_port=")[1].nil?
   #     host_port = "-p " + t.split("host_port=")[1] + " "
   #   elsif t.include? "host_password="
   #     host_password = t.split("host_password=")[1]
   #   end
   # end

    puts  @config["project_path"]
    puts  @config["server_name"]
    puts  @config["host_user"]
    puts  @config["host_ip"]
    puts  @config["host_port"]
    puts  @config["host_password"]
    return `sshpass -p#{@config["host_password"]} ssh #{@config["host_port"]} #{@config["host_user"]}@#{@config["host_ip"]} gluster volume info`
  end
  
  def file_upload
    file_name = params[:file]
    uploader = AvatarUploader.new
    uploader.store!(file_name)
    redirect_to '/volume/info'
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
  
  def volume_mount
	conf_list = get_conf
	host_ip = String.new
	  conf_list.each do |t|
		  if t.include? "host_ip="
		  	host_ip = t.split("host_ip=")[1]
		  end
	  end
	  volume_name = params[:volume_name]
	  volume_name = volume_name.delete(' ')
	  puts "mount -t glusterfs " +  host_ip + ":/" + volume_name + " /mnt/glusterfs"
    redirect_to '/volume/index'
  end

  def volume_stop
	  volume_name = params[:volume_name]
	  volume_name = volume_name.delete(' ')
	  
	  host_user = "root"
    host_ip = "127.0.0.1"
    host_password = "secret"
    host_port = ""

    @conf_list.each do |t|
      if t.include? "host_name="
        host_user = t.split("host_user=")[1]
      elsif t.include? "host_ip="
        host_ip = t.split("host_ip=")[1]
      elsif t.include? "host_port=" and !t.split("host_port=")[1].nil?
        host_port = "-p " + t.split("host_port=")[1] + " "
      elsif t.include? "host_password="
        host_password = t.split("host_password=")[1]
      end
    end

	  puts "gluster volume stop " + volume_name
	  output = `sshpass -p#{host_password} ssh #{host_port} #{host_user}@#{host_ip} gluster volume stop #{volume_name}`
    redirect_to '/volume/index'
  end

  def volume_start
	  volume_name = params[:volume_name]
	  volume_name = volume_name.delete(' ')
	  
	   
	  host_user = "root"
    host_ip = "127.0.0.1"
    host_password = "secret"
    host_port = ""

    @conf_list.each do |t|
      if t.include? "host_name="
        host_user = t.split("host_user=")[1]
      elsif t.include? "host_ip="
        host_ip = t.split("host_ip=")[1]
      elsif t.include? "host_port=" and !t.split("host_port=")[1].nil?
        host_port = "-p " + t.split("host_port=")[1] + " "
      elsif t.include? "host_password="
        host_password = t.split("host_password=")[1]
      end
    end
    
	  puts "gluster volume start " + volume_name
	  output = `sshpass -p#{host_password} ssh #{host_port} #{host_user}@#{host_ip} gluster volume start #{volume_name}`
    redirect_to '/volume/index'
  end
  
  
  def volume_delete
	  volume_name = params[:volume_name]
	  volume_name = volume_name.delete(' ')
	  
	   
	  host_user = "root"
    host_ip = "127.0.0.1"
    host_password = "secret"
    host_port = ""

    @conf_list.each do |t|
      if t.include? "host_name="
        host_user = t.split("host_user=")[1]
      elsif t.include? "host_ip="
        host_ip = t.split("host_ip=")[1]
      elsif t.include? "host_port=" and !t.split("host_port=")[1].nil?
        host_port = "-p " + t.split("host_port=")[1] + " "
      elsif t.include? "host_password="
        host_password = t.split("host_password=")[1]
      end
    end
    
	  puts "gluster volume start " + volume_name
	  output = `sshpass -p#{host_password} ssh #{host_port} #{host_user}@#{host_ip} gluster volume delete #{volume_name}`
    redirect_to '/volume/index'
  end
end
