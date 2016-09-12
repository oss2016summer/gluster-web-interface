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
                String state = (df.include? volume['Volume Name'].delete(' ')) ? "mounted" : "unmounted"
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
        command = String.new
        command << "sshpass -p" + @config["host_password"].to_s
        command << " ssh "
        if !@config["host_port"].nil?
            command << "-p " + @config["host_port"].to_s + " "
        end
        command << @config["host_user"].to_s + "@" + @config["host_ip"].to_s
        command << " gluster volume info"
        puts command
        return `#{command}`
    end

    def file_upload
        file_name = params[:file]
        uploader = AvatarUploader.new
        uploader.store!(file_name)
        redirect_to '/volume/info'
    end

    def volume_mount
        get_conf
        volume_name = params[:volume_name]
        mount_point = params[:mount_point]
        # make command string
        command = String.new
        command << "mount -t glusterfs " + @config["host_ip"].to_s + ":/" + volume_name + " " + mount_point
        puts command
        `#{command}`
        redirect_to '/volume/index'
    end

    def volume_unmount
        get_conf
        volume_name = params[:volume_name]
        # make command string
        command = String.new
        command << "umount " + @config["host_ip"].to_s + ":/" + volume_name
        puts command
        `#{command}`
        redirect_to '/volume/index'
    end

    def volume_create
        get_conf
        volume_name = params[:volume_name]
        volume_type = params[:volume_type]
        num_of_brick = params[:num_of_brick]
        bricks = params[:bricks]
        # make command string
        command = String.new
        command << "sshpass -p" + @config["host_password"].to_s
        command << " ssh "
        if !@config["host_port"].nil?
            command << "-p " + @config["host_port"].to_s + " "
        end
        command << @config["host_user"].to_s + "@" + @config["host_ip"].to_s
        command << " gluster volume create " + volume_name + " "
        if !volume_type.equal? "Distribute"
            command << volume_type.downcase + " " + num_of_brick + " "
        end
        bricks.each do |t|
            command << t + " "
        end
        command << "force"
        puts command
        `#{command}`
        redirect_to '/volume/index'
    end

    def volume_stop
        get_conf
        volume_name = params[:volume_name]
        # make command string
        command = String.new
        command << "yes | sshpass -p" + @config["host_password"].to_s
        command << " ssh "
        if !@config["host_port"].nil?
            command << "-p " + @config["host_port"].to_s + " "
        end
        command << @config["host_user"].to_s + "@" + @config["host_ip"].to_s
        command << " gluster volume stop " + volume_name
        puts command
        `#{command}`
        redirect_to '/volume/index'
    end

    def volume_start
        get_conf
        volume_name = params[:volume_name]
        # make command string
        command = String.new
        command << "sshpass -p" + @config["host_password"].to_s
        command << " ssh "
        if !@config["host_port"].nil?
            command << "-p " + @config["host_port"].to_s + " "
        end
        command << @config["host_user"].to_s + "@" + @config["host_ip"].to_s
        command << " gluster volume start " + volume_name
        puts command
        `#{command}`
        redirect_to '/volume/index'
    end

    def volume_delete
        get_conf
        volume_name = params[:volume_name]
        # make command string
        command = String.new
        command << "yes | sshpass -p" + @config["host_password"].to_s
        command << " ssh "
        if !@config["host_port"].nil?
            command << "-p " + @config["host_port"].to_s + " "
        end
        command << @config["host_user"].to_s + "@" + @config["host_ip"].to_s
        command << " gluster volume delete " + volume_name
        puts command
        `#{command}`
        redirect_to '/volume/index'
    end
end
