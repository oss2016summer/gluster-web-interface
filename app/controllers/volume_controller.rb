class VolumeController < ApplicationController
    before_action :require_login

    def index
        @current_dir = "/mnt"
    end

    def chdir
        @current_dir = params[:next_dir]
        puts "current_dir : " + @current_dir
        render :json => {
            :dir => @current_dir,
            :mount_table => mount_table(@current_dir),
        }
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
        node = Node.take
        volume_name = params[:volume_name]
        mount_point = params[:mount_point]
        # make command string
        command = String.new
        command << "sudo mount -t glusterfs #{node.host_ip}:/#{volume_name} #{mount_point}"
        puts command
        `#{command}`
        redirect_to '/volume/index'
    end

    def volume_unmount
        node = Node.take
        volume_name = params[:volume_name]
        # make command string
        command = String.new
        command << "sudo umount #{node.host_ip}:/#{volume_name}"
        puts command
        `#{command}`
        redirect_to '/volume/index'
    end

    def volume_create
        node = Node.take
        volume_name = params[:volume_name]
        volume_type = params[:volume_type]
        num_of_brick = params[:num_of_brick]
        bricks = params[:bricks]
        # make command string
        command = String.new
        command << "sshpass -p#{node.user_password} "
        command << "ssh #{node.host_name}@#{node.host_ip} "
        command << "gluster volume create #{volume_name} "
        if !volume_type.include? "Distribute"
            command << "#{volume_type.downcase} #{num_of_brick}"
        end
        nodes = Node.all
        bricks.each do |t|
            host_name = t.split(":/")[0]
            brick_name = t.split(":/")[1]
            host_ip = ""
            nodes.each do |u|
                next if !u.host_name.eql? host_name
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
        node = Node.take
        volume_name = params[:volume_name]
        # make command string
        command = String.new
        command << "yes | sshpass -p#{node.user_password} "
        command << "ssh #{node.host_name}@#{node.host_ip} "
        command << "gluster volume stop #{volume_name}"
        puts command
        `#{command}`
        redirect_to '/volume/index'
    end

    def volume_start
        node = Node.take
        volume_name = params[:volume_name]
        # make command string
        command = String.new
        command << "sshpass -p#{node.user_password} "
        command << "ssh #{node.host_name}@#{node.host_ip} "
        command << " gluster volume start #{volume_name}"
        puts command
        `#{command}`
        redirect_to '/volume/index'
    end

    def volume_delete
        node = Node.take
        volume_name = params[:volume_name]
        # make command string
        command = String.new
        command << "yes | sshpass -p#{node.user_password} "
        command << "ssh #{node.host_name}@#{node.host_ip} "
        command << " gluster volume delete #{volume_name}"
        puts command
        `#{command}`
        redirect_to '/volume/index'
    end
end
