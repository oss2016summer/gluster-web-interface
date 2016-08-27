class VolumeController < ApplicationController
  def info
    mnt_path = "/opt/gluster-web-interface/app/mntpoint"
    @volumes = Array.new
    volume = Hash.new
    i = 0

    if get_info.blank?
      flash[:danger] = "Check Server"
    else
      output = get_info.split("\n")
      for t in 1..(output.length-1)
         if output[t].include? ":" 
           temp = output[t].split(":")
           volume[temp[0]] = temp[1]
         else  
           volume["files"] = file_directory(mnt_path + "/" + volume["Volume Name"].delete(' '), volume["Volume Name"].delete(' '))
           @volumes[i] = volume
           volume = Hash.new
           i+=1
         end
      end
      volume["files"] = file_directory(mnt_path + "/" + volume["Volume Name"].delete(' '), volume["Volume Name"].delete(' '))
      @volumes[i] = volume
      puts @volumes
    end
  end

  def get_info
    return `sshpass -pakfm77 ssh -p 2222 root@124.63.216.174 gluster volume info`
  end
  
  def file_upload
    file_name = params[:file]
    uploader = AvatarUploader.new
    uploader.store!(file_name)
    redirect_to '/volume/info'
  end
  
  
  def file_directory(dir, dir_name)
    puts "start///////"
    puts "dir: " + dir
    puts "dir_name: " + dir_name


    @current_dir = dir
    `sudo mkdir #{dir}`
    `sudo mount.glusterfs gluster-1:/#{dir_name} #{dir}`

    dir_list = `ls #{@current_dir} -l`

    puts dir_list

    parsing_list = dir_list.split("\n")
    
    
    files = Array.new
    file = Hash.new
    i = 0
    @total_list = parsing_list[0]
      for t in 1..(parsing_list.length-1)
         puts "@@@@@@@@@@@" + parsing_list[t]
         parsing_file = parsing_list[t].split(" ")
         file["auth"] = parsing_file[0]
         file["size"] = parsing_file[4]
         file["date"] =  parsing_file[5] + " " + parsing_file[6] + " "+ parsing_file[7]
         file["name"] = parsing_file[8]
         @files[i] = file
         file = Hash.new
         i+=1
      end
      puts files

    return files
  end
end
