module ApplicationHelper

    def get_conf
        conf = Hash.new
        node = Node.take
        if !node.nil?
            conf["host_name"] = node.host_name
            conf["host_ip"] = node.host_ip
            conf["user_name"] = node.user_name
            conf["user_password"] = node.user_password
        end
        return conf
    end

    def get_conf_all
        conf_all = Array.new
        conf = Hash.new
        nodes = Node.all
        nodes.each do |node|
            conf["host_name"] = node.host_name
            conf["host_ip"] = node.host_ip
            conf["user_name"] = node.user_name
            conf["user_password"] = node.user_password
            conf_all << conf
            conf = Hash.new
        end
        return conf_all
    end

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

    def users
        users = User.all
        return users
    end

    def nodes
        nodes = Node.all
        return nodes
    end

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
end
