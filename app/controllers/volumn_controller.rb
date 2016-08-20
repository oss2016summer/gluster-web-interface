class VolumnController < ApplicationController
  def info
    @output = get_info.split("\n")
  end

  def get_info
    return `sshpass -pakfm77 ssh root@gluster-1 gluster volume info`
  end
  
end
