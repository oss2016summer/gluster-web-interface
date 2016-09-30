class NodeController < ApplicationController
    before_action :require_login
  def index
    @hosts = Array.new
    @nodes = Node.all.order("id asc")
    
    @node_connects = Array.new
    node_info = Hash.new
    one_node = Node.take
    
    node_info["Hostname"] = one_node.host_name
    node_info["State"] = "Peer in Cluster Disconnected"
    node_info = Hash.new
    
    if !one_node.blank?
      if ping_test?(one_node.host_ip)
        command = String.new
        command << "sshpass -p#{one_node.user_password} ssh #{one_node.user_name}@#{one_node.host_ip} gluster peer status info"
        puts command
        output = `#{command}`.split("\n")
        output << "\n"
  
        output.each do |t|
            next if t.equal? output.first
            if t.include? ":"
                temp = t.split(":")
                node_info[temp[0]] = temp[1]
            else
                @node_connects << node_info
                node_info = Hash.new
            end
        end
      
      end
    end
  
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
  
  def node_prove
    one_node = Node.find(params[:node_id])
    puts "gluster peer probe #{one_node.host_name}"
    redirect_to '/node/index'
  end
  
  def node_detach
    one_node = Node.find(params[:node_id])
    puts "gluster peer detach #{one_node.host_name}"
    redirect_to '/node/index'
  end
end
