class PeerController < ApplicationController
  def index
    @hosts = Array.new
    
    if get_hosts.blank?
      flash[:danger] = "Check Server"
    else
      @hosts = get_hosts
      
    end
  end
  
  def get_hosts
    file_str = `cat ` + @hostfile_path
    hosts_str = file_str.split("hosts:")[1]
    return hosts_str.split("\n")
  end
  
  @hostfile_path = "../../../configure.conf"
end
