class VolumeController < ApplicationController
  helper_method :file_directory
  
  def info
    file_directory('/home/ubuntu')
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
           @volumes[i] = volume
           volume = Hash.new
           i+=1
         end
      end
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
  
  
  def file_directory(dir)
    @current_dir = dir
    dir_list = `ls #{@current_dir} -l`
    parsing_list = dir_list.split("\n")
    @files = Array.new
    file = Hash.new
    i = 0
    @total_list = parsing_list[0]
      for t in 1..(parsing_list.length-1)
        parsing_file = parsing_list[t].split(" ")
        file["auth"] = parsing_file[0]
        file["size"] = parsing_file[4]
        file["date"] =  parsing_file[5] + " " + parsing_file[6] + " "+ parsing_file[7]
        file["name"] = parsing_file[8]
        @files[i] = file
        file = Hash.new
        i+=1
      end
      puts @files
  end
  
    
  def change_file_directory(dir)
    @change_dir = dir
    dir_list = `ls #{@change_dir} -l`
    parsing_list = dir_list.split("\n")
    @change_files = Array.new
    file = Hash.new
    i = 0
    @change_total_list = parsing_list[0]
      for t in 1..(parsing_list.length-1)
        parsing_file = parsing_list[t].split(" ")
        file["auth"] = parsing_file[0]
        file["size"] = parsing_file[4]
        file["date"] =  parsing_file[5] + " " + parsing_file[6] + " "+ parsing_file[7]
        file["name"] = parsing_file[8]
        @change_files[i] = file
        file = Hash.new
        i+=1
      end
      puts @change_files
  end
  
  def checkDir
    file_directory(params[:path])
    render :json => {:file => @files , :current => @current_dir}
  end
end
