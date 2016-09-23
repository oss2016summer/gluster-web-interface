module VolumeHelper

    def volumes
        volumes = Array.new
        volume = Hash.new
        conf = get_conf
        df = get_df
        command = String.new
        command << "sshpass -p#{conf['user_password']} "
        command << "ssh #{conf['user_name']}@#{conf['host_ip']} "
        command << "gluster volume info"
        puts command
        output = `#{command}`.split("\n")
        output << "\n"
        output.each do |t|
            next if t.equal? output.first
            if t.include? ":"
                temp = t.split(":")
                volume[temp[0]] = temp[1]
            else
                volume['Mount State'] = "unmounted"
                df.each do |u|
                    next if !u['Filesystem'].include? volume['Volume Name'].delete(' ')
                    volume['Mount State'] = "mounted"
                    volume['Mount Point'] = u['Mounted on']
                end
                volumes << volume
                volume = Hash.new
            end
        end
        return volumes
    end

    def volume_info(volume)
        params = ['Type', 'Volume ID', 'Status', 'Number of Bricks', 'Transport-type', 'Bricks', 'Options Reconfigured', 'Mount State', 'Mount Point']
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
