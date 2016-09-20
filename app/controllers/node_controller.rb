class NodeController < ApplicationController
  def index
    @hosts = Array.new
    @nodes = Node.all.order("id asc") 
    
    if get_hosts.blank?
      flash[:danger] = "Check Server"
    else
      @hosts = get_hosts
    end
  end

  def get_hosts
    return ['2', 'aaa', 'bbb', 'ccc']
  end
  
  def node_add
    new_node = Node.new	
    new_node.host_name = params[:host_name]
    new_node.host_ip = params[:host_ip]
    new_node.host_port = params[:host_port]
    new_node.user_name = params[:user_name]
    new_node.user_password = params[:user_password]
    new_node.save
    redirect_to '/node/index'
  end
  
  def node_delete
    one_node = Node.find(params[:node_id])
    one_node.destroy
    redirect_to '/node/index'
  end
end
