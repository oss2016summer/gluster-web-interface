module ApplicationHelper
    require 'net/ping'

    def get_df
        df = Array.new
        df_each = Hash.new
        command = String.new
        command << "df -hP"
        puts command
        output = `#{command}`.split("\n")
        output.each do |t|
            next if t.equal? output.first
            begin
                s = t.split(' ')
                df_each['Filesystem'] = s[0]
                df_each['Size'] = s[1]
                df_each['Used'] = s[2]
                df_each['Avail'] = s[3]
                df_each['Use%'] = s[4]
                df_each['Mounted on'] = s[5]
                df << df_each
                df_each = Hash.new
            rescue => ex
                puts ex
            end
        end
        return df
    end

    def get_du(dir = @current_dir)
        du = Array.new
        du_each = Hash.new
        command = String.new
        avail = 0.0
        if dir.eql? "/"
            command = "sudo df /"
            s = `#{command}`.split("\n")[1].split(" ")
            avail = s[2].to_f + s[3].to_f
            dir = ""
        else
            command << "sudo du -s #{dir}"
            begin
                avail = `#{command}`.split(" ")[0].to_f
            rescue
                # some directory is not connected
                avail = `#{command}`.split(" ")[1].to_f
            end
        end

        command = ""
        command << "sudo du -s #{dir}/*"
        puts command
        output = `#{command}`.split("\n")
        output.each do |t|
            begin
                du_each['size'] = t.split(" ")[0].to_i
                du_each['usage'] = t.split(" ")[0].to_f / avail
                du_each['file_name'] = t.split(" ")[1].split("/").last
                du << du_each
                du_each = Hash.new
            rescue
                # directory is not connected
                du_each['size'] = 0
                du_each['usage'] = 0.0
                du_each['file_name'] = t.split(" ")[1].split("/").last.split("'")[0]
                du << du_each
                du_each = Hash.new
            end
        end

        if du.length == 0
            du_each['size'] = 0
            du_each['usage'] = 1.0
            du_each['file_name'] = "empty"
            du << du_each
        end

        du.sort_by! { |k| k['usage'] }
        du.reverse!
        return du
    end

    def ssh_volume_info
        volumes = Array.new
        volume = Hash.new
        node = Node.take
        df = get_df
        # error check : node is nil
        if node.nil?
            return volumes
        end
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

    def ssh_nodes
        nodes = Array.new
        node = Hash.new
        db_nodes = Node.all.order("id asc")
        db_nodes.each do |db_node|
            node["id"] = db_node.id
            node["host_name"] = db_node.host_name
            node["host_ip"] = db_node.host_ip
            node["user_name"] = db_node.user_name
            node["user_password"] = db_node.user_password
            node["created_at"] = db_node.created_at
            node["updated_at"] = db_node.updated_at
            node["ping"] = (ping_test?(db_node.host_ip) ? "true" : "false")

            begin
                if node["ping"].eql? "true"
                    command = String.new
                    command << "sshpass -p#{node["user_password"]} ssh #{node["user_name"]}@#{node["host_ip"]} gluster peer status"
                    puts command
                    output = `#{command}`.split("\n")

                    if output[0].include? "Number of Peers"
                        node["ssh"] = "on"
                        node["gluster"] = "on"
                        node["number_of_peers"] = output[0].split(": ")[1]
                        # put peers
                    elsif output[0].include? "check if gluster daemon is operational."
                        node["ssh"] = "on"
                        node["gluster"] = "off"
                    else
                        node["ssh"] = "off"
                        node["gluster"] = "off"
                    end
                end
            rescue => ex
                puts ex
            end
            
            nodes << node
            node = Hash.new
        end
        return nodes
    end

    def ssh_peer_probe
    end

    def ssh_peer_detach
    end

    def files(dir)
        files = Array.new
        file = Hash.new
        command = String.new
        command << "ls #{dir} -l"
        puts command
        output = `#{command}`.split("\n")
        output.each do |t|
            next if t.equal? output.first
            begin
                s = t.split(" ")
                file["auth"] = s[0]
                file["size"] = s[4]
                file["date"] = s[5] + " " + s[6] + " " + s[7]
                file["name"] = s[8]
                files << file
                file = Hash.new
            rescue => ex
                puts ex
            end
        end
        return files
    end

    def ping_test?(host)
      check = Net::Ping::External.new(host)
      return check.ping?
    end
end
