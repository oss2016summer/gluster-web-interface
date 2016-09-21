class VolumeController < ApplicationController

    def index
        file_directory("/mnt")
        get_conf
    end

    def get_df
        return `df -P`
    end

    def file_upload
        df = get_df
        mnt_dir = String.new
        mnt_dest = String.new
        file = params[:file]
        s = df.split("\n")
        s.each do |t|
            if t.include? params[:volume_name]
                mnt_dir = t.split(" ")[5]
            end
        end
        mnt_dest = mnt_dir + "/" + file.original_filename
        # change permission
        command = String.new
        command << "sudo chmod 777 " + mnt_dir
        puts command
        `#{command}`
        u = AvatarUploader.new(mnt_dir)
        u.store!(file)
        redirect_to '/volume/index'
    end

    def volume_mount
        get_conf
        volume_name = params[:volume_name]
        mount_point = params[:mount_point]
        # make command string
        command = String.new
        command << "sudo mount -t glusterfs " + @config["host_ip"].to_s + ":/" + volume_name + " " + mount_point
        puts command
        `#{command}`
        redirect_to '/volume/index'
    end

    def volume_unmount
        get_conf
        volume_name = params[:volume_name]
        # make command string
        command = String.new
        command << "sudo umount " + @config["host_ip"].to_s + ":/" + volume_name
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
        command << "sshpass -p" + @config["user_password"].to_s
        command << " ssh "
        
        command << @config["user_name"].to_s + "@" + @config["host_ip"].to_s
        command << " gluster volume create " + volume_name + " "
        if !volume_type.include? "Distribute"
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
        command << "yes | sshpass -p" + @config["user_password"].to_s
        command << " ssh "
       
        command << @config["user_name"].to_s + "@" + @config["host_ip"].to_s
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
        command << "sshpass -p" + @config["user_password"].to_s
        command << " ssh "
     
        command << @config["user_name"].to_s + "@" + @config["host_ip"].to_s
        command << " gluster volume start " + volume_name.to_s
        puts command
        `#{command}`
        redirect_to '/volume/index'
    end

    def volume_delete
        get_conf
        volume_name = params[:volume_name]
        # make command string
        command = String.new
        command << "yes | sshpass -p" + @config["user_password"].to_s
        command << " ssh "
 
        command << @config["user_name"].to_s + "@" + @config["host_ip"].to_s
        command << " gluster volume delete " + volume_name
        puts command
        `#{command}`
        redirect_to '/volume/index'
    end
end
