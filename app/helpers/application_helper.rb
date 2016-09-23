module ApplicationHelper

    def get_conf
        config = Hash.new
        one_node = Node.take
        if !one_node.nil?
            config["host_name"] = one_node.host_name
            config["host_ip"] = one_node.host_ip
            config["user_name"] = one_node.user_name
            config["user_password"] = one_node.user_password
        end
        return config
    end

    def get_conf_all
        config = Array.new
        config_each = Hash.new
        all_node = Node.all
        all_node.each do |one_node|
            config_each["host_name"] = one_node.host_name
            config_each["host_ip"] = one_node.host_ip
            config_each["user_name"] = one_node.user_name
            config_each["user_password"] = one_node.user_password
            config << config_each
            config_each = Hash.new
        end
        return config
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

end
