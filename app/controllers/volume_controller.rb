class VolumeController < ApplicationController

  def index
    file_directory("/mnt")
    get_conf
    info = get_info.split("\n")
    
    if info.blank?
      flash[:danger] = "Check Server"
    else
      parse_info(info)
    end
  end
  
  def parse_info(info)
    @volumes = Array.new
    volume = Hash.new
    df = get_df
    
    info.each do |t|
      next if t.equal? info.first
      
      if t.include? ":" 
        temp = t.split(":")
        volume[temp[0]] = temp[1]
      else
        if df.include? volume['Volume Name'].delete(' ')
          volume['Mount State'] = "Mounted"
        else
          volume['Mount State'] = "UnMounted"
        end
        puts volume['Volume Name'] + ": " + volume['Mount State']
         
        @volumes << volume
        volume = Hash.new
      end
    end
    @volumes << volume
    
  end

  def get_df
    return `df -P`
  end

  def get_info
    return `sshpass -p#{@config["host_password"]} ssh #{@config["host_port"]} #{@config["host_user"]}@#{@config["host_ip"]} gluster volume info`
  end
  
  def file_upload
    file_name = params[:file]
    uploader = AvatarUploader.new
    uploader.store!(file_name)
    redirect_to '/volume/info'
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
	  output = `yes | sshpass -p#{@config["host_password"]} ssh #{@config["host_port"]} #{@config["host_user"]}@#{@config["host_ip"]} gluster volume delete #{volume_name}`
    redirect_to '/volume/index'
  end
end
