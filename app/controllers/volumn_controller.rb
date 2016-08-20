class VolumnController < ApplicationController
  def info
    @output = `ls`
  end
end
