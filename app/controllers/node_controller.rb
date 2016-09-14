class NodeController < ApplicationController
  def index
    @hosts = Array.new

    if get_hosts.blank?
      flash[:danger] = "Check Server"
    else
      @hosts = get_hosts
    end
  end

  def get_hosts
    return ['2', 'aaa', 'bbb', 'ccc']
  end
end
