module VolumeHelper

    def get_conf
      @config = Hash.new

      one_node = Node.take
      if !one_node.nil?
        @config["host_name"] = one_node.host_name
        @config["host_ip"] = one_node.host_ip
        @config["user_name"] = one_node.user_name
        @config["user_password"] = one_node.user_password
      end
      return @config
    end

    def get_volumes
        volumes = Array.new
        volume = Hash.new
        command = "df -P"
        df = `#{command}`
        conf = get_conf
        command = "sshpass -p#{conf['user_password']} ssh #{conf['user_name']}@#{conf['host_ip']} gluster volume info"
        info = `#{command}`.split("\n")
        info << "\n"
        info.each do |t|
            next if t.equal? info.first
            if t.include? ":"
                temp = t.split(":")
                volume[temp[0]] = temp[1]
            else
                String state = (df.include? volume['Volume Name'].delete(' ')) ? "mounted" : "unmounted"
                volume['Mount State'] = state
                if state.eql? "mounted"
                    s = df.split("\n")
                    s.each do |t|
                        if t.include? volume['Volume Name'].delete(' ')
                            mnt_point = t.split(" ")[5]
                            volume['Mount Point'] = mnt_point
                        end
                    end
                end
                volumes << volume
                volume = Hash.new
            end
        end
        return volumes
    end

    def volume_info(volume)
        params = ['Type', 'Volume ID', 'Status', 'Number of Bricks', 'Transport-type',
            'Bricks', 'Options Reconfigured', 'Mount State', 'Mount Point']
        html = ''
        html << "<div>"
        params.each do |t|
            next if volume[t].nil?
            html << "<p>"
            html << t + " : " + volume[t]
            html << "</p>"
        end
        html << "</div>"
        raw(html)
    end
end
