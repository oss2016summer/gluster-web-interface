class VolumnController < ApplicationController
  def info
    @volumes = Array.new
    volume = Hash.new
    i = 0
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

  def get_info
    return `sshpass -pakfm77 ssh -p 2222 root@gluster-1 gluster volume info`
  end
  
end
