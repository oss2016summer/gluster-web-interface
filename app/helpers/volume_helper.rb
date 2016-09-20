module VolumeHelper

    def get_conf
      config = Hash.new
      output = `cat configure.conf`.split("\n")
      output.each do |t|
        if t.include? "project_path="
          config["project_path"] = t.split("project_path=")[1]
        elsif t.include? "server_name="
          config["server_name"] = t.split("server_name=")[1]
        elsif t.include? "host_user="
          config["host_user"] = t.split("host_user=")[1]
        elsif t.include? "host_ip="
          config["host_ip"] = t.split("host_ip=")[1]
        elsif t.include? "host_port=" and !t.split("host_port=")[1].nil?
          config["host_port"] = t.split("host_port=")[1] + " "
        elsif t.include? "host_password="
          config["host_password"] = t.split("host_password=")[1]
        end
      end
      return config
    end

    def get_volumes
        volumes = Array.new
        volume = Hash.new
        command = "df -P"
        df = `#{command}`
        conf = get_conf
        command = "sshpass -p#{conf['host_password']} ssh #{conf['host_user']}@#{conf['host_ip']} gluster volume info"
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
