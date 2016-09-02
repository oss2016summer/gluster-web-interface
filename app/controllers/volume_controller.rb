class VolumeController < ApplicationController
  
  def index
    @config = get_conf
    @volumes = Array.new
    volume = Hash.new
    
    file_directory(@config["project_path"])
    
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
      # puts @volumes
    end
  end


  def get_info
    @config = get_conf
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
    @config = get_conf
	  volume_name = params[:volume_name]
	  mount_point = params[:mount_point]
	  volume_name = volume_name.delete(' ')
	  puts "mount -t glusterfs " +  @config["host_ip"] + ":/" + volume_name + " " + mount_point
		
	  `mount -t glusterfs #{@config["host_ip"]}:/#{volume_name} #{mount_point}`
		
	  redirect_to '/volume/index'
  end

  def volume_stop
    @config = get_conf
	  volume_name = params[:volume_name]
	  volume_name = volume_name.delete(' ')
	  puts "gluster volume stop " + volume_name
	  output = `yes | sshpass -p#{@config["host_password"]} ssh #{@config["host_port"]} #{@config["host_user"]}@#{@config["host_ip"]} gluster volume stop #{volume_name}`
    redirect_to '/volume/index'
  end

  def volume_start
    @config = get_conf
	  volume_name = params[:volume_name]
	  volume_name = volume_name.delete(' ')
	  puts "gluster volume start " + volume_name
    output = `sshpass -p#{@config["host_password"]} ssh #{@config["host_port"]} #{@config["host_user"]}@#{@config["host_ip"]} gluster volume start #{volume_name}`
    redirect_to '/volume/index'
  end
  
  
  def volume_delete
    @config = get_conf
	  volume_name = params[:volume_name]
	  volume_name = volume_name.delete(' ')
	  puts "gluster volume delete " + volume_name
	  #output = `sshpass -p#{@config["host_password"]} ssh #{@config["host_port"]} #{@config["host_user"]}@#{@config["host_ip"]} gluster volume delete #{volume_name}`
    redirect_to '/volume/index'
  end
end
