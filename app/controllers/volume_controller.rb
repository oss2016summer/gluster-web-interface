class VolumeController < ApplicationController

    def index
        file_directory("/mnt")
    end

    def file_upload
        df = get_df
        mnt_dir = String.new
        mnt_dest = String.new
        file = params[:file]
        df.each do |t|
            if t['Filesystem'].include? params[:volume_name]
                mnt_dir = t['Mounted on']
            end
        end
        mnt_dest = mnt_dir + "/" + file.original_filename
        # change permission
        command = String.new
        command << "sudo chmod 777 #{mnt_dir}"
        puts command
        `#{command}`
        # upload file
        u = AvatarUploader.new(mnt_dir)
        u.store!(file)
        redirect_to '/volume/index'
    end

    def volume_mount
        conf = get_conf
        volume_name = params[:volume_name]
        mount_point = params[:mount_point]
        # make command string
        command = String.new
        command << "sudo mount -t glusterfs #{conf['host_ip']}:/#{volume_name} #{mount_point}"
        puts command
        `#{command}`
        redirect_to '/volume/index'
    end

    def volume_unmount
        conf = get_conf
        volume_name = params[:volume_name]
        # make command string
        command = String.new
        command << "sudo umount #{conf['host_ip']}:/#{volume_name}"
        puts command
        `#{command}`
        redirect_to '/volume/index'
    end

    def volume_create
        conf = get_conf
        volume_name = params[:volume_name]
        volume_type = params[:volume_type]
        num_of_brick = params[:num_of_brick]
        bricks = params[:bricks]
        # make command string
        command = String.new
        command << "sshpass -p#{conf['user_password']} "
        command << "ssh #{conf['user_name']}@#{conf['host_ip']} "
        command << "gluster volume create #{volume_name} "
        if !volume_type.include? "Distribute"
            command << "#{volume_type.downcase} #{num_of_brick}"
        end
        conf_all = get_conf_all
        bricks.each do |t|
            host_name = t.split(":/")[0]
            brick_name = t.split(":/")[1]
            host_ip = ""
            conf_all.each do |u|
                next if !u['host_name'].eql? host_name
                host_ip = u['host_ip']
            end
            brick = "#{host_ip}:/#{brick_name}"
            command << "#{brick} "
        end
        command << "force"
        puts command
        `#{command}`
        redirect_to '/volume/index'
    end

    def volume_stop
        conf = get_conf
        volume_name = params[:volume_name]
        # make command string
        command = String.new
        command << "yes | sshpass -p#{conf['user_password']} "
        command << "ssh #{conf['user_name']}@#{conf['host_ip']} "
        command << "gluster volume stop #{volume_name}"
        puts command
        `#{command}`
        redirect_to '/volume/index'
    end

    def volume_start
        conf = get_conf
        volume_name = params[:volume_name]
        # make command string
        command = String.new
        command << "sshpass -p#{conf['user_password']} "
        command << "ssh #{conf['user_name']}@#{conf['host_ip']} "
        command << " gluster volume start #{volume_name}"
        puts command
        `#{command}`
        redirect_to '/volume/index'
    end

    def volume_delete
        conf = get_conf
        volume_name = params[:volume_name]
        # make command string
        command = String.new
        command << "yes | sshpass -p#{conf['user_password']} "
        command << "ssh #{conf['user_name']}@#{conf['host_ip']} "
        command << " gluster volume delete #{volume_name}"
        puts command
        `#{command}`
        redirect_to '/volume/index'
    end
end
