module ApplicationHelper

    def get_df
        df = Array.new
        df_each = Hash.new
        command = String.new
        command << "df -hP"
        puts command
        output = `#{command}`.split("\n")
        output.each do |t|
            next if t.equal? output.first
            s = t.split(' ')
            df_each['Filesystem'] = s[0]
            df_each['Size'] = s[1]
            df_each['Used'] = s[2]
            df_each['Avail'] = s[3]
            df_each['Use%'] = s[4]
            df_each['Mounted on'] = s[5]
            df << df_each
            df_each = Hash.new
        end
        return df
    end

    def volumes
        volumes = Array.new
        volume = Hash.new
        node = Node.take
        df = get_df
        command = String.new
        command << "sshpass -p#{node.user_password} ssh #{node.user_name}@#{node.host_ip} gluster volume info"
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

end
