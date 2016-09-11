class VolumeController < ApplicationController

    def index
        file_directory("/mnt")
        get_conf
        info = get_volume_info.split("\n")
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
        info << "\n"
        info.each do |t|
            next if t.equal? info.first
            if t.include? ":"
                temp = t.split(":")
                volume[temp[0]] = temp[1]
            else
                String state = (df.include? volume['Volume Name'].delete(' ')) ? "Mounted" : "UnMounted"
                volume['Mount State'] = state
                @volumes << volume
                volume = Hash.new
            end
        end
    end

    def get_df
        return `df -P`
    end

    def get_volume_info
        return `sshpass -p#{@config["host_password"]} ssh #{@config["host_port"]} #{@config["host_user"]}@#{@config["host_ip"]} \
         gluster volume info`
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
        puts "mount -t glusterfs " +  @config["host_ip"] + ":/" + volume_name + " " + mount_point
        `mount -t glusterfs #{@config["host_ip"]}:/#{volume_name} #{mount_point}`
        redirect_to '/volume/index'
    end

    def volume_unmount
        @config = get_conf
        volume_name = params[:volume_name]
        puts "umount " + @config["host_ip"] + ":/" + volume_name
        `umount #{@config["host_ip"]}:/#{volume_name}`
        redirect_to '/volume/index'
    end

    def volume_create
	@config = get_conf
        volume_name = params[:volume_name]
	volume_type = params[:volume_type]
	num_of_brick = params[:num_of_brick]
        bricks = params[:bricks]
	command = String.new
	command << "sshpass"
	command << " -p"
	command << @config["host_password"].to_s
	command << " ssh "
	command << @config["host_port"].to_s
	command << " "
	command << @config["host_user"].to_s
	command << "@"
	command << @config["host_ip"].to_s
	command << " gluster volume create "
	command << volume_name + " "
	if !volume_type.include? "Distribute"
		command << volume_type + " " + num_of_brick + " "
	end
        bricks.each do |t|
            command << t
            command << " "
        end
	command << "force"
        puts command
        `#{command}`
        redirect_to '/volume/index'
    end

    def volume_stop
        @config = get_conf
        volume_name = params[:volume_name]
        puts "gluster volume stop " + volume_name
        `yes | sshpass -p#{@config["host_password"]} ssh #{@config["host_port"]} #{@config["host_user"]}@#{@config["host_ip"]} \
         gluster volume stop #{volume_name}`
        redirect_to '/volume/index'
    end

    def volume_start
        @config = get_conf
        volume_name = params[:volume_name]
        puts "gluster volume start " + volume_name
        `sshpass -p#{@config["host_password"]} ssh #{@config["host_port"]} #{@config["host_user"]}@#{@config["host_ip"]} \
        gluster volume start #{volume_name}`
        redirect_to '/volume/index'
    end


    def volume_delete
        @config = get_conf
        volume_name = params[:volume_name]
        puts "gluster volume delete " + volume_name
        `yes | sshpass -p#{@config["host_password"]} ssh #{@config["host_port"]} #{@config["host_user"]}@#{@config["host_ip"]} \
        gluster volume delete #{volume_name}`
        redirect_to '/volume/index'
    end
end
