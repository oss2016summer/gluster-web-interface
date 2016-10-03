class NodeController < ApplicationController
    before_action :require_login

    def index
    end
    def detail
        @node_id = params[:node_id]
        #@detail_node = Node.find(params[:node_id])
        
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

    def node_probe
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
